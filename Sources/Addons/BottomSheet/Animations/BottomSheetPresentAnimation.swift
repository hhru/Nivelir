#if canImport(UIKit)
import UIKit

@MainActor
internal class BottomSheetPresentAnimation: NSObject {

    private var animator: UIViewImplicitlyAnimating?

    internal let options: BottomSheetAnimationOptions

    internal init(options: BottomSheetAnimationOptions) {
        self.options = options
    }

    private func makeAnimator(
        using transitionContext: UIViewControllerContextTransitioning
    ) -> UIViewPropertyAnimator {
        let animator = UIViewPropertyAnimator(
            duration: transitionDuration(using: transitionContext),
            curve: options.curve
        )

        animator.addCompletion { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }

        guard let presentedView = transitionContext.view(forKey: .to) else {
            return animator
        }

        guard let presentedViewController = transitionContext.viewController(forKey: .to) else {
            return animator
        }

        let transitionHeight = transitionContext
            .finalFrame(for: presentedViewController)
            .height

        let presentedViewFrame = presentedView.frame

        presentedView.frame = presentedViewFrame.offsetBy(
            dx: .zero,
            dy: transitionHeight
        )

        animator.addAnimations {
            presentedView.frame = presentedViewFrame
        }

        return animator
    }
}

extension BottomSheetPresentAnimation: UIViewControllerAnimatedTransitioning {

    internal func transitionDuration(
        using transitionContext: UIViewControllerContextTransitioning?
    ) -> TimeInterval {
        options.duration
    }

    internal func animateTransition(
        using transitionContext: UIViewControllerContextTransitioning
    ) {
        interruptibleAnimator(using: transitionContext).startAnimation()
    }

    internal func interruptibleAnimator(
        using transitionContext: UIViewControllerContextTransitioning
    ) -> UIViewImplicitlyAnimating {
        if let animator {
            return animator
        }

        let animator = makeAnimator(using: transitionContext)

        animator.addCompletion { [weak self] _ in
            self?.animator = nil
        }

        self.animator = animator

        return animator
    }
}
#endif
