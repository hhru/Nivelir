#if canImport(UIKit)
import UIKit

internal final class BottomSheetDetentionController {

    private var cachedDetentValues: [BottomSheetDetentKey: CGFloat?] = [:]

    private var cachedSmallestDetentValue: CGFloat?
    private var cachedLargestDetentValue: CGFloat?
    private var cachedCurrentDetentValue: CGFloat?

    internal let presentedViewController: UIViewController

    internal var keyboardHeight: CGFloat = .zero {
        didSet {
            cachedLargestDetentValue = nil
            cachedCurrentDetentValue = nil
        }
    }

    internal var maximumDetentValue: CGFloat = .zero {
        didSet { invalidateDetents() }
    }

    internal var detents: [BottomSheetDetent] = [.large] {
        didSet { invalidateDetents() }
    }

    internal var selectedDetentKey: BottomSheetDetentKey? {
        didSet {
            cachedCurrentDetentValue = nil

            if selectedDetentKey != oldValue {
                delegate?.bottomSheetDidChangeSelectedDetentKey(
                    to: selectedDetentKey
                )
            }
        }
    }

    internal weak var delegate: BottomSheetDetentionDelegate?

    internal init(presentedViewController: UIViewController) {
        self.presentedViewController = presentedViewController
    }

    internal func resolveDetentValue(detent: BottomSheetDetent) -> CGFloat? {
        if let cachedDetentValue = cachedDetentValues[detent.key] {
            return cachedDetentValue
        }

        let detentValue = detent
            .resolve(for: self)
            .map { min($0, maximumDetentValue) }
            .map { $0 > .leastNonzeroMagnitude ? $0 : maximumDetentValue }

        cachedDetentValues[detent.key] = detentValue

        return detentValue
    }

    internal func resolveDetentValue(key: BottomSheetDetentKey) -> CGFloat? {
        if let detentValue = cachedDetentValues[key] {
            return detentValue
        }

        guard let detent = detents.first(where: { $0.key == key }) else {
            return nil
        }

        return resolveDetentValue(detent: detent)
    }

    internal func resolveSmallestDetentValue() -> CGFloat {
        if let cachedSmallestDetentValue {
            return cachedSmallestDetentValue
        }

        let smallestDetentValue = detents
            .compactMap(resolveDetentValue(detent:))
            .min() ?? .zero

        self.cachedSmallestDetentValue = smallestDetentValue

        return smallestDetentValue
    }

    internal func resolveLargestDetentValue() -> CGFloat {
        if let cachedLargestDetentValue {
            return cachedLargestDetentValue
        }

        let largestDetentValue = detents
            .compactMap(resolveDetentValue(detent:))
            .max()
            .map { min($0 + keyboardHeight, maximumDetentValue) } ?? .zero

        self.cachedLargestDetentValue = largestDetentValue

        return largestDetentValue
    }

    internal func resolveCurrentDetentValue() -> CGFloat {
        if let cachedCurrentDetentValue {
            return cachedCurrentDetentValue
        }

        let selectedDetentValue = selectedDetentKey
            .flatMap(resolveDetentValue(key:))
            .map { min($0 + keyboardHeight, maximumDetentValue) }

        let currentDetentValue = selectedDetentValue ?? detents
            .lazy
            .filter { $0.key != self.selectedDetentKey }
            .compactMap(resolveDetentValue(detent:))
            .map { min($0 + self.keyboardHeight, self.maximumDetentValue) }
            .min() ?? .zero

        self.cachedCurrentDetentValue = currentDetentValue

        return currentDetentValue
    }

    internal func resolveNearestDetentKey(for height: CGFloat) -> BottomSheetDetentKey? {
        let detentDeltas = detents
            .map(resolveDetentValue(detent:))
            .enumerated()
            .lazy
            .compactMap { detentIndex, detentValue in
                detentValue.map { (index: detentIndex, delta: abs($0 - height)) }
            }

        return detentDeltas
            .min { $0.delta < $1.delta }
            .map { $0.index }
            .map { detents[$0] }
            .map { $0.key }
    }

    internal func selectNearestDetent(for height: CGFloat) {
        guard let nearestDetentKey = resolveNearestDetentKey(for: height) else {
            return
        }

        let nearestDetentValue = resolveDetentValue(key: nearestDetentKey) ?? .zero
        let currentDetentValue = resolveCurrentDetentValue()

        guard abs(nearestDetentValue - currentDetentValue) > .leastNonzeroMagnitude else {
            return
        }

        selectedDetentKey = nearestDetentKey

        if delegate?.bottomSheetCanEndEditing() ?? true {
            presentedViewController.view.endEditing(false)
        }
    }

    internal func invalidateDetents() {
        cachedDetentValues = [:]

        cachedSmallestDetentValue = nil
        cachedLargestDetentValue = nil
        cachedCurrentDetentValue = nil
    }
}

extension BottomSheetDetentionController: BottomSheetDetentContext {

    internal var containerTraitCollection: UITraitCollection {
        presentedViewController.view.traitCollection
    }
}
#endif
