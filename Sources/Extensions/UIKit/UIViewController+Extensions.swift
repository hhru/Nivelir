import UIKit

extension UIViewController {

    public var presented: UIViewController? {
        presentedViewController
    }

    public var presenting: UIViewController? {
        presentingViewController
    }

    public var stack: UINavigationController? {
        navigationController
    }

    public var tabs: UITabBarController? {
        tabBarController
    }
}
