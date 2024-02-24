#if canImport(UIKit)
import UIKit

internal final class BottomSheetPresentingInteraction: BottomSheetInteraction {

    internal private(set) var gestureInitialValue: CGFloat
    internal private(set) var currentDetentDelta: CGFloat

    internal var canRecognizeGestures: Bool {
        false
    }

    internal init(previousInteraction: BottomSheetInteraction) {
        gestureInitialValue = previousInteraction.gestureInitialValue
        currentDetentDelta = previousInteraction.currentDetentDelta
    }

    private func resolveGestureValue(
        presentationController: BottomSheetPresentationController,
        gestureTranslation: CGPoint
    ) -> CGFloat {
        min(
            gestureInitialValue - gestureTranslation.y,
            presentationController.detention.maximumDetentValue
        )
    }

    private func resolveCurrentDetentDelta(
        presentationController: BottomSheetPresentationController,
        gestureValue: CGFloat
    ) -> CGFloat {
        let currentDetentValue = presentationController
            .detention
            .resolveCurrentDetentValue()

        guard gestureValue > currentDetentValue + .leastNonzeroMagnitude else {
            return .zero
        }

        let largestDetentValue = presentationController
            .detention
            .resolveLargestDetentValue()

        if gestureValue > largestDetentValue + .leastNonzeroMagnitude {
            let largestDetentDelta = largestDetentValue - currentDetentValue

            let rubberBandEffect = presentationController.rubberBandEffect?(
                value: gestureValue,
                limit: largestDetentValue
            ) ?? .zero

            return largestDetentDelta + rubberBandEffect
        }

        return gestureValue - currentDetentValue
    }

    private func resolveTransitionRatio(
        presentationController: BottomSheetPresentationController,
        gestureValue: CGFloat
    ) -> CGFloat {
        let currentDetentValue = presentationController
            .detention
            .resolveCurrentDetentValue()

        let currentDetentDelta = currentDetentValue - gestureValue

        guard currentDetentDelta > .leastNonzeroMagnitude else {
            return .zero
        }

        let transitionHeight = presentationController
            .frameOfPresentedViewInContainerView
            .height

        return transitionHeight > .leastNonzeroMagnitude
            ? 1.0 - currentDetentDelta / transitionHeight
            : 1.0
    }

    internal func start(
        presentationController: BottomSheetPresentationController,
        gestureRecognizer: UIPanGestureRecognizer,
        simultaneousScrollView: UIScrollView?
    ) {
        presentationController.transition.pause()

        let currentDetentValue = presentationController
            .detention
            .resolveCurrentDetentValue()

        let transitionHeight = presentationController
            .frameOfPresentedViewInContainerView
            .height

        let transitionRatio = presentationController
            .transition
            .percentComplete

        presentationController
            .transition
            .update(transitionRatio)

        gestureInitialValue = currentDetentValue - (1.0 - transitionRatio) * transitionHeight

        currentDetentDelta = resolveCurrentDetentDelta(
            presentationController: presentationController,
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
            gestureTranslation: gestureRecognizer.translation(in: nil)
        )

        let transitionRatio = resolveTransitionRatio(
            presentationController: presentationController,
            gestureValue: gestureValue
        )

        let currentDetentValue = presentationController
            .detention
            .resolveCurrentDetentValue()

        presentationController
            .transition
            .update(transitionRatio)

        if gestureValue >= currentDetentValue - .leastNonzeroMagnitude {
            presentationController.transition.finish()
        }

        currentDetentDelta = resolveCurrentDetentDelta(
            presentationController: presentationController,
            gestureValue: gestureValue
        )
    }

    internal func finish(
        presentationController: BottomSheetPresentationController,
        gestureRecognizer: UIPanGestureRecognizer,
        simultaneousScrollView: UIScrollView?
    ) {
        let gesturePredictedValue = resolveGestureValue(
            presentationController: presentationController,
            gestureTranslation: gestureRecognizer.predictedTranslation(
                in: nil,
                decelerationRate: .fast
            )
        )

        let currentDetentValue = presentationController
            .detention
            .resolveCurrentDetentValue()

        if gesturePredictedValue > 0.5 * currentDetentValue {
            presentationController.transition.finish()

            presentationController
                .detention
                .selectNearestDetent(for: gesturePredictedValue)
        } else {
            let canDismissByGesture = presentationController
                .delegate?
                .presentationControllerShouldDismiss?(presentationController) ?? true

            if canDismissByGesture {
                presentationController.transition.cancel()
            } else {
                presentationController.transition.finish()

                presentationController
                    .delegate?
                    .presentationControllerDidAttemptToDismiss?(presentationController)
            }
        }

        gestureInitialValue = .zero
        currentDetentDelta = .zero
    }

    internal func cancel(
        presentationController: BottomSheetPresentationController,
        gestureRecognizer: UIPanGestureRecognizer,
        simultaneousScrollView: UIScrollView?
    ) {
        presentationController.transition.finish()

        gestureInitialValue = .zero
        currentDetentDelta = .zero
    }
}
#endif
