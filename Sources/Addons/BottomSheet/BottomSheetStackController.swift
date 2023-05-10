#if canImport(UIKit)
import UIKit

open class BottomSheetStackController: UINavigationController {

    private var isUpdatingStack = false

    private func updatePreferredContentSizeIfNeeded() {
        guard isPresentedAsBottomSheet, let topViewController else {
            return
        }

        let preferredContentWidth = topViewController
            .preferredContentSize
            .width + additionalSafeAreaInsets.horizontal

        let preferredContentHeight = topViewController
            .preferredContentSize
            .height + additionalSafeAreaInsets.vertical

        let preferredContentSize = CGSize(
            width: preferredContentWidth,
            height: preferredContentHeight
        )

        if self.preferredContentSize != preferredContentSize {
            self.preferredContentSize = preferredContentSize
        }
    }

    private func updateStack<Output>(animated: Bool, changes: () -> Output) -> Output {
        isUpdatingStack = true

        let output = changes()

        if let transitionCoordinator = transitionCoordinator, animated, transitionCoordinator.isAnimated {
            transitionCoordinator.animate(
                alongsideTransition: { _ in },
                completion: { _ in
                    self.updatePreferredContentSizeIfNeeded()

                    self.isUpdatingStack = false
                }
            )
        } else {
            updatePreferredContentSizeIfNeeded()

            isUpdatingStack = false
        }

        return output
    }

    open override func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        updateStack(animated: animated) {
            super.setViewControllers(viewControllers, animated: animated)
        }
    }

    open override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        updateStack(animated: animated) {
            super.pushViewController(viewController, animated: animated)
        }
    }

    open override func popViewController(animated: Bool) -> UIViewController? {
        updateStack(animated: animated) {
            super.popViewController(animated: animated)
        }
    }

    open override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        updateStack(animated: animated) {
            super.popToRootViewController(animated: animated)
        }
    }

    open override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
        super.preferredContentSizeDidChange(forChildContentContainer: container)

        if !isUpdatingStack {
            updatePreferredContentSizeIfNeeded()
        }
    }
}
#endif
