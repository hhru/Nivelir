#if canImport(UIKit)
import UIKit

extension UIViewController {

    public var bottomSheet: BottomSheetController? {
        guard let presentedViewController = presentingViewController?.presentedViewController else {
            return nil
        }

        guard presentedViewController.modalPresentationStyle == .custom else {
            return nil
        }

        return presentedViewController.transitioningDelegate as? BottomSheetController
    }

    public var isPresentedAsBottomSheet: Bool {
        bottomSheet != nil
    }
}
#endif
