#if canImport(UIKit)
import UIKit

extension UIWindow {

    public var root: UIViewController? {
        rootViewController
    }
}
#endif
