#if canImport(UIKit)
import UIKit

internal final class BottomSheetPresentedInteraction: BottomSheetInteraction {

    private var canDismissByGesture = true

    internal private(set) var gestureInitialValue: CGFloat
    internal private(set) var currentDetentDelta: CGFloat

    internal var canRecognizeGestures: Bool {
        true
    }

    internal init(previousInteraction: BottomSheetInteraction) {
        gestureInitialValue = previousInteraction.gestureInitialValue
        currentDetentDelta = previousInteraction.currentDetentDelta
    }

    private func resolveGestureValue(
        presentationController: BottomSheetPresentationController,
        simultaneousScrollView: UIScrollView?,
        gestureTranslation: CGPoint
    ) -> CGFloat {
        let canScrollVertically = simultaneousScrollView?.canScrollVertically ?? false

        if canScrollVertically, !presentationController.prefersScrollingExpandsHeight {
            return gestureInitialValue - max(gestureTranslation.y, .zero)
        }

        return min(
            gestureInitialValue - gestureTranslation.y,
            presentationController.detention.maximumDetentValue
        )
    }

    private func resolveCurrentDetentDelta(
        presentationController: BottomSheetPresentationController,
        simultaneousScrollView: UIScrollView?,
        gestureValue: CGFloat
    ) -> CGFloat {
        let currentDetentValue = presentationController
            .detention
            .resolveCurrentDetentValue()

        if presentationController.presentedViewController.isBeingDismissed {
            return min(gestureValue - currentDetentValue, .zero)
        }

        let largestDetentValue = presentationController
            .detention
            .resolveLargestDetentValue()

        if gestureValue > largestDetentValue + .leastNonzeroMagnitude {
            let largestDetentDelta = largestDetentValue - currentDetentValue
            let largestDetentExcess = gestureValue - largestDetentValue

            return simultaneousScrollView?.canScrollVertically ?? false
                ? largestDetentDelta
                : largestDetentDelta + 2.0 * largestDetentExcess.squareRoot()
        }

        let smallestDetentValue = presentationController
            .detention
            .resolveSmallestDetentValue()

        if gestureValue < smallestDetentValue - .leastNonzeroMagnitude {
            let smallestDetentDelta = smallestDetentValue - currentDetentValue
            let smallestDetentExcess = smallestDetentValue - gestureValue

            return smallestDetentDelta - 2.0 * smallestDetentExcess.squareRoot()
        }

        return gestureValue - currentDetentValue
    }

    private func dismissPresentedViewControllerIfNeeded(
        presentationController: BottomSheetPresentationController,
        gestureValue: CGFloat,
        isGestureFinished: Bool
    ) {
        guard !presentationController.presentedViewController.isBeingDismissed else {
            return
        }

        guard canDismissByGesture else {
            return
        }

        let smallestDetentValue = presentationController
            .detention
            .resolveSmallestDetentValue()

        let dismissalThreshold = isGestureFinished
            ? smallestDetentValue * 0.5
            : smallestDetentValue

        guard gestureValue < dismissalThreshold - .leastNonzeroMagnitude else {
            return
        }

        canDismissByGesture = presentationController
            .delegate?
            .presentationControllerShouldDismiss?(presentationController) ?? true

        guard canDismissByGesture else {
            return
        }

        presentationController
            .transition
            .wantsInteractiveStart = !isGestureFinished

        presentationController
            .presentingViewController
            .dismiss(animated: true)
    }

    internal func start(
        presentationController: BottomSheetPresentationController,
        gestureRecognizer: UIPanGestureRecognizer,
        simultaneousScrollView: UIScrollView?
    ) {
        canDismissByGesture = true

        gestureInitialValue = presentationController
            .detention
            .resolveCurrentDetentValue()

        currentDetentDelta = resolveCurrentDetentDelta(
            presentationController: presentationController,
            simultaneousScrollView: simultaneousScrollView,
            gestureValue: gestureInitialValue
        )
    }

    internal func update(
        presentationController: BottomSheetPresentationController,
        gestureRecognizer: UIPanGestureRecognizer,
        simultaneousScrollView: UIScrollView?
    ) {
        let gestureValue = resolveGestureValue(
            presentationController: presentationController,
            simultaneousScrollView: simultaneousScrollView,
            gestureTranslation: gestureRecognizer.translation(in: nil)
        )

        dismissPresentedViewControllerIfNeeded(
            presentationController: presentationController,
            gestureValue: gestureValue,
            isGestureFinished: false
        )

        if presentationController.presentedViewController.isBeingDismissed {
            presentationController
                .detention
                .selectNearestDetent(for: gestureValue)
        }

        currentDetentDelta = resolveCurrentDetentDelta(
            presentationController: presentationController,
            simultaneousScrollView: simultaneousScrollView,
            gestureValue: gestureValue
        )
    }

    internal func finish(
        presentationController: BottomSheetPresentationController,
        gestureRecognizer: UIPanGestureRecognizer,
        simultaneousScrollView: UIScrollView?
    ) {
        let gestureProjectedValue = resolveGestureValue(
            presentationController: presentationController,
            simultaneousScrollView: simultaneousScrollView,
            gestureTranslation: gestureRecognizer.projectedTranslation(
                in: nil,
                decelerationRate: .fast
            )
        )

        dismissPresentedViewControllerIfNeeded(
            presentationController: presentationController,
            gestureValue: gestureProjectedValue,
            isGestureFinished: true
        )

        presentationController
            .detention
            .selectNearestDetent(for: gestureProjectedValue)

        if !canDismissByGesture {
            canDismissByGesture = true

            presentationController
                .delegate?
                .presentationControllerDidAttemptToDismiss?(presentationController)
        }

        if presentationController.presentedViewController.isBeingDismissed {
            let gestureValue = resolveGestureValue(
                presentationController: presentationController,
                simultaneousScrollView: simultaneousScrollView,
                gestureTranslation: gestureRecognizer.translation(in: nil)
            )

            gestureInitialValue = .zero

            currentDetentDelta = resolveCurrentDetentDelta(
                presentationController: presentationController,
                simultaneousScrollView: simultaneousScrollView,
                gestureValue: gestureValue
            )
        } else {
            gestureInitialValue = .zero
            currentDetentDelta = .zero
        }
    }

    internal func cancel(
        presentationController: BottomSheetPresentationController,
        gestureRecognizer: UIPanGestureRecognizer,
        simultaneousScrollView: UIScrollView?
    ) {
        canDismissByGesture = true

        gestureInitialValue = .zero
        currentDetentDelta = .zero
    }
}
#endif
