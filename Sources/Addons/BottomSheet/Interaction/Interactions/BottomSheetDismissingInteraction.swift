#if canImport(UIKit)
import UIKit

internal final class BottomSheetDismissingInteraction: BottomSheetInteraction {

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

        guard gestureValue > currentDetentValue + .leastNonzeroMagnitude else {
            return .zero
        }

        let largestDetentValue = presentationController
            .detention
            .resolveLargestDetentValue()

        if gestureValue > largestDetentValue + .leastNonzeroMagnitude {
            let largestDetentDelta = largestDetentValue - currentDetentValue

            if simultaneousScrollView?.canScrollVertically ?? false {
                return largestDetentDelta
            }

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
            ? currentDetentDelta / transitionHeight
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

        let transitionExtraRatio = transitionHeight > .leastNonzeroMagnitude
            ? currentDetentDelta / transitionHeight
            : 1.0

        let transitionRatio = presentationController
            .transition
            .percentComplete - transitionExtraRatio

        presentationController
            .transition
            .update(transitionRatio)

        gestureInitialValue = currentDetentValue - transitionRatio * transitionHeight

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
            presentationController.transition.cancel()
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
        let gesturePredictedValue = resolveGestureValue(
            presentationController: presentationController,
            simultaneousScrollView: simultaneousScrollView,
            gestureTranslation: gestureRecognizer.predictedTranslation(
                in: nil,
                decelerationRate: .fast
            )
        )

        let smallestDetentValue = presentationController
            .detention
            .resolveSmallestDetentValueIgnoringKeyboard()

        if gesturePredictedValue > 0.5 * smallestDetentValue {
            presentationController.transition.cancel()

            presentationController
                .detention
                .selectNearestDetent(for: gesturePredictedValue)
        } else {
            presentationController.transition.finish()
        }

        gestureInitialValue = .zero
        currentDetentDelta = .zero
    }

    internal func cancel(
        presentationController: BottomSheetPresentationController,
        gestureRecognizer: UIPanGestureRecognizer,
        simultaneousScrollView: UIScrollView?
    ) {
        presentationController.transition.cancel()

        gestureInitialValue = .zero
        currentDetentDelta = .zero
    }
}
#endif
