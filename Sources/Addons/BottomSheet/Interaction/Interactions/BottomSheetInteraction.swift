#if canImport(UIKit)
import UIKit

internal protocol BottomSheetInteraction {

    var gestureInitialValue: CGFloat { get }
    var currentDetentDelta: CGFloat { get }

    var canRecognizeGestures: Bool { get }

    func start(
        presentationController: BottomSheetPresentationController,
        gestureRecognizer: UIPanGestureRecognizer,
        simultaneousScrollView: UIScrollView?
    )

    func update(
        presentationController: BottomSheetPresentationController,
        gestureRecognizer: UIPanGestureRecognizer,
        simultaneousScrollView: UIScrollView?
    )

    func finish(
        presentationController: BottomSheetPresentationController,
        gestureRecognizer: UIPanGestureRecognizer,
        simultaneousScrollView: UIScrollView?
    )

    func cancel(
        presentationController: BottomSheetPresentationController,
        gestureRecognizer: UIPanGestureRecognizer,
        simultaneousScrollView: UIScrollView?
    )
}
#endif
