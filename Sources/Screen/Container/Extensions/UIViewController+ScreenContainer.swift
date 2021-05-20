#if canImport(UIKit)
import UIKit

extension UIViewController: ScreenContainer {

    public var isVisible: Bool {
        viewIfLoaded?.window != nil
    }
}
#endif
