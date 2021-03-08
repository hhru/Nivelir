import UIKit

extension UITabBarController {

    public var selectedTab: UIViewController? {
        get { selectedViewController }
        set { selectedViewController = newValue }
    }
}
