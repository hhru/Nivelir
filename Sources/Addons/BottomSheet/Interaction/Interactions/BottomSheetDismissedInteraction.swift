#if canImport(UIKit)
import UIKit

internal final class BottomSheetDismissedInteraction: BottomSheetInteraction {

    internal var gestureInitialValue: CGFloat {
        .zero
    }

    internal var currentDetentDelta: CGFloat {
        .zero
    }

    internal var canRecognizeGestures: Bool {
        false
    }

    internal func start(
        presentationController: BottomSheetPresentationController,
        gestureRecognizer: UIPanGestureRecognizer,
        simultaneousScrollView: UIScrollView?
    ) { }

    internal func update(
        presentationController: BottomSheetPresentationController,
        gestureRecognizer: UIPanGestureRecognizer,
        simultaneousScrollView: UIScrollView?
    ) { }

    internal func finish(
        presentationController: BottomSheetPresentationController,
        gestureRecognizer: UIPanGestureRecognizer,
        simultaneousScrollView: UIScrollView?
    ) { }

    internal func cancel(
        presentationController: BottomSheetPresentationController,
        gestureRecognizer: UIPanGestureRecognizer,
        simultaneousScrollView: UIScrollView?
    ) { }
}
#endif
