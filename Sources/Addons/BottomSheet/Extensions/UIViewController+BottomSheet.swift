#if canImport(UIKit)
import UIKit

extension UIViewController {

    public var bottomSheet: BottomSheetController? {
        let viewController = presenting?.presented ?? self

        guard viewController.modalPresentationStyle == .custom else {
            return nil
        }

        return viewController.transitioningDelegate as? BottomSheetController
    }

    public var isPresentedAsBottomSheet: Bool {
        (bottomSheet != nil) && (presenting != nil)
    }
}
#endif
