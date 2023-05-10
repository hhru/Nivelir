#if canImport(UIKit)
import UIKit

internal final class BottomSheetDimmingView: UIView {

    private let containerView = UIView()
    private let blurEffectView = UIVisualEffectView()

    internal private(set) weak var presentingView: UIView?

    internal var color: UIColor? {
        get { containerView.backgroundColor }
        set { containerView.backgroundColor = newValue}
    }

    internal var ratio: CGFloat {
        get { containerView.alpha }
        set { containerView.alpha = newValue }
    }

    internal var blurStyle: UIBlurEffect.Style? {
        didSet {
            if blurStyle != oldValue {
                updateBlurEffectView()
            }
        }
    }

    internal init(presentingView: UIView, frame: CGRect = .zero) {
        self.presentingView = presentingView

        super.init(frame: frame)

        setupContainerView()
        setupBlurEffectView()
    }

    @available(*, unavailable)
    internal required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func layoutContainerView() {
        containerView.frame = bounds
    }

    private func setupContainerView() {
        addSubview(containerView)

        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.isUserInteractionEnabled = false
    }

    private func updateBlurEffectView() {
        blurEffectView.effect = blurStyle.map(UIBlurEffect.init(style:))
        blurEffectView.isHidden = blurEffectView.effect == nil
    }

    private func layoutBlurEffectView() {
        blurEffectView.frame = containerView.bounds
    }

    private func setupBlurEffectView() {
        containerView.addSubview(blurEffectView)

        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        blurEffectView.isUserInteractionEnabled = false

        updateBlurEffectView()
    }

    internal override func layoutSubviews() {
        super.layoutSubviews()

        layoutContainerView()
        layoutBlurEffectView()
    }

    internal override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard ratio <= .leastNormalMagnitude else {
            return super.hitTest(point, with: event)
        }

        guard self.point(inside: point, with: event) else {
            return nil
        }

        return presentingView?.hitTest(
            convert(point, to: presentingView),
            with: event
        )
    }
}
#endif
