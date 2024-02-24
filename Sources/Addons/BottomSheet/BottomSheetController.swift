#if canImport(UIKit)
import UIKit

public class BottomSheetController: NSObject {

    private weak var presentation: BottomSheetPresentationController?

    public var detents: [BottomSheetDetent] {
        didSet {
            if presentation?.detents.map({ $0.key }) != detents.map({ $0.key }) {
                presentation?.detents = detents
            }
        }
    }

    public var selectedDetentKey: BottomSheetDetentKey? {
        didSet {
            if presentation?.selectedDetentKey != selectedDetentKey {
                presentation?.selectedDetentKey = selectedDetentKey
            }
        }
    }

    public var preferredDimming: BottomSheetDimming {
        didSet {
            if presentation?.preferredDimming != preferredDimming {
                presentation?.preferredDimming = preferredDimming
            }
        }
    }

    public var preferredCard: BottomSheetCard {
        didSet {
            if presentation?.preferredCard != preferredCard {
                presentation?.preferredCard = preferredCard
            }
        }
    }

    public var preferredGrabber: BottomSheetGrabber? {
        didSet {
            if presentation?.preferredGrabber != preferredGrabber {
                presentation?.preferredGrabber = preferredGrabber
            }
        }
    }

    public var prefferedGrabberForMaximumDetentValue: BottomSheetGrabber? {
        didSet {
            if presentation?.prefferedGrabberForMaximumDetentValue != prefferedGrabberForMaximumDetentValue {
                presentation?.prefferedGrabberForMaximumDetentValue = prefferedGrabberForMaximumDetentValue
            }
        }
    }

    public var prefersScrollingExpandsHeight: Bool {
        didSet {
            if presentation?.prefersScrollingExpandsHeight != prefersScrollingExpandsHeight {
                presentation?.prefersScrollingExpandsHeight = prefersScrollingExpandsHeight
            }
        }
    }

    public var prefersWidthFollowsPreferredContentSize: Bool {
        didSet {
            if presentation?.prefersWidthFollowsPreferredContentSize != prefersWidthFollowsPreferredContentSize {
                presentation?.prefersWidthFollowsPreferredContentSize = prefersWidthFollowsPreferredContentSize
            }
        }
    }

    public var prefersEdgeAttachedInCompactHeight: Bool {
        didSet {
            if presentation?.prefersEdgeAttachedInCompactHeight != prefersEdgeAttachedInCompactHeight {
                presentation?.prefersEdgeAttachedInCompactHeight = prefersEdgeAttachedInCompactHeight
            }
        }
    }

    public var rubberBandEffect: BottomSheetRubberBandEffect? {
        didSet { presentation?.rubberBandEffect = rubberBandEffect }
    }

    public var changesAnimationOptions: BottomSheetAnimationOptions {
        didSet {
            if presentation?.changesAnimationOptions != changesAnimationOptions {
                presentation?.changesAnimationOptions = changesAnimationOptions
            }
        }
    }

    public var presentAnimationOptions: BottomSheetAnimationOptions
    public var dismissAnimationOptions: BottomSheetAnimationOptions

    public var canEndEditing: (() -> Bool)?
    public var shouldDismiss: (() -> Bool)?

    public var didAttemptToDismiss: (() -> Void)?

    public var willDismiss: (() -> Void)?
    public var didDismiss: (() -> Void)?

    public var didChangeSelectedDetentKey: ((_ detentKey: BottomSheetDetentKey?) -> Void)?

    public init(bottomSheet: BottomSheet = .default) {
        self.detents = bottomSheet.detents
        self.selectedDetentKey = bottomSheet.selectedDetentKey

        self.preferredDimming = bottomSheet.preferredDimming
        self.preferredCard = bottomSheet.preferredCard
        self.preferredGrabber = bottomSheet.preferredGrabber
        self.prefferedGrabberForMaximumDetentValue = bottomSheet.prefferedGrabberForMaximumDetentValue

        self.prefersScrollingExpandsHeight = bottomSheet.prefersScrollingExpandsHeight
        self.prefersWidthFollowsPreferredContentSize = bottomSheet.prefersWidthFollowsPreferredContentSize
        self.prefersEdgeAttachedInCompactHeight = bottomSheet.prefersEdgeAttachedInCompactHeight

        self.changesAnimationOptions = bottomSheet.changesAnimationOptions
        self.presentAnimationOptions = bottomSheet.presentAnimationOptions
        self.dismissAnimationOptions = bottomSheet.dismissAnimationOptions

        self.rubberBandEffect = bottomSheet.rubberBandEffect

        self.canEndEditing = bottomSheet.canEndEditing
        self.shouldDismiss = bottomSheet.shouldDismiss

        self.didAttemptToDismiss = bottomSheet.didAttemptToDismiss

        self.willDismiss = bottomSheet.willDismiss
        self.didDismiss = bottomSheet.didDismiss

        self.didChangeSelectedDetentKey = bottomSheet.didChangeSelectedDetentKey
    }

    public func animateChanges(_ changes: @escaping (_ bottomSheet: BottomSheetController) -> Void) {
        guard let presentation else {
            return changes(self)
        }

        presentation.animateChanges {
            changes(self)
        }
    }

    public func invalidateDetents() {
        presentation?.invalidateDetents()
    }
}

extension BottomSheetController: UIAdaptivePresentationControllerDelegate {

    public func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        shouldDismiss?() ?? true
    }

    public func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        didAttemptToDismiss?()
    }

    public func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
        willDismiss?()
    }

    public func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        didDismiss?()
    }
}

extension BottomSheetController: BottomSheetDetentionDelegate {

    internal func bottomSheetCanEndEditing() -> Bool {
        canEndEditing?() ?? true
    }

    internal func bottomSheetDidChangeSelectedDetentKey(to detentKey: BottomSheetDetentKey?) {
        guard selectedDetentKey != detentKey else {
            return
        }

        selectedDetentKey = detentKey

        didChangeSelectedDetentKey?(detentKey)
    }
}

extension BottomSheetController: UIViewControllerTransitioningDelegate {

    public func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController
    ) -> UIPresentationController? {
        let presentation = BottomSheetPresentationController(
            presentedViewController: presented,
            presenting: presenting ?? source
        )

        presentation.delegate = self
        presentation.detention.delegate = self

        presentation.detents = detents
        presentation.selectedDetentKey = selectedDetentKey

        presentation.preferredDimming = preferredDimming
        presentation.preferredCard = preferredCard
        presentation.preferredGrabber = preferredGrabber
        presentation.prefferedGrabberForMaximumDetentValue = prefferedGrabberForMaximumDetentValue

        presentation.prefersScrollingExpandsHeight = prefersScrollingExpandsHeight
        presentation.prefersWidthFollowsPreferredContentSize = prefersWidthFollowsPreferredContentSize
        presentation.prefersEdgeAttachedInCompactHeight = prefersEdgeAttachedInCompactHeight

        presentation.changesAnimationOptions = changesAnimationOptions
        presentation.rubberBandEffect = rubberBandEffect

        self.presentation = presentation

        return presentation
    }

    public func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        BottomSheetPresentAnimation(options: presentAnimationOptions)
    }

    public func animationController(
        forDismissed dismissed: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        BottomSheetDismissAnimation(options: dismissAnimationOptions)
    }

    public func interactionControllerForPresentation(
        using animator: UIViewControllerAnimatedTransitioning
    ) -> UIViewControllerInteractiveTransitioning? {
        presentation?.transition
    }

    public func interactionControllerForDismissal(
        using animator: UIViewControllerAnimatedTransitioning
    ) -> UIViewControllerInteractiveTransitioning? {
        presentation?.transition
    }
}
#endif
