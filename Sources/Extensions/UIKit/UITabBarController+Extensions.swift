#if canImport(UIKit)
import UIKit

extension UITabBarController {

    /// The container associated with the currently selected tab item.
    ///
    /// This container is the one whose custom view is currently displayed by the tab bar interface.
    /// The specified container must be in the `viewControllers` array.
    /// Assigning a new container to this property changes the currently displayed view
    /// and also selects an appropriate tab in the tab bar.
    /// Changing the container also updates the `selectedIndex` property accordingly.
    /// The default value of this property is `nil`.
    ///
    /// You can use this property to select any of the containers in the `viewControllers` property.
    /// This includes containers that are managed by the More navigation controller
    /// and whose tab bar items are not visible in the tab bar.
    /// You can also use it to select the More navigation controller itself,
    /// which is available from the `moreNavigationController` property.
    ///
    /// - SeeAlso: `selectedViewController`
    public var selectedTab: UIViewController? {
        get { selectedViewController }
        set { selectedViewController = newValue }
    }
}
#endif
