#if canImport(UIKit)
import UIKit

internal class BottomSheetDismissAnimation: NSObject {

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

        guard let dismissedView = transitionContext.view(forKey: .from) else {
            return animator
        }

        guard let dismissedViewController = transitionContext.viewController(forKey: .from) else {
            return animator
        }

        let transitionHeight = transitionContext
            .initialFrame(for: dismissedViewController)
            .height

        animator.addAnimations {
            dismissedView.frame = dismissedView.frame.offsetBy(
                dx: .zero,
                dy: transitionHeight
            )
        }

        return animator
    }
}

extension BottomSheetDismissAnimation: UIViewControllerAnimatedTransitioning {

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
