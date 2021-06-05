#if canImport(UIKit)
import UIKit

extension UIViewController {

    public var presenting: UIViewController? {
        presentingViewController
    }

    public var presented: UIViewController? {
        presentedViewController
    }

    public var presentedStack: UINavigationController? {
        presented as? UINavigationController
    }

    public var presentedTabs: UITabBarController? {
        presented as? UITabBarController
    }

    public var stack: UINavigationController? {
        navigationController
    }

    public var tabs: UITabBarController? {
        tabBarController
    }
}
#endif
