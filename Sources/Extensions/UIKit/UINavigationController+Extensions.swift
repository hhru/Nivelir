#if canImport(UIKit)
import UIKit

extension UINavigationController {

    public var stackRoot: UIViewController? {
        viewControllers.first
    }

    public var stackTop: UIViewController? {
        topViewController
    }

    public var stackVisible: UIViewController? {
        visibleViewController
    }
}
#endif
