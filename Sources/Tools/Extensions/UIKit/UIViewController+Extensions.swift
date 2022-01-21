#if canImport(UIKit)
import UIKit

extension UIViewController {

    /// The container that presented this container.
    ///
    /// When you present a container modally (either explicitly or implicitly)
    /// using the `present(_:animated:completion:)` method,
    /// the container that was presented has this property set to the container that presented it.
    /// If the container was not presented modally, but one of its ancestors was,
    /// this property contains the container that presented the ancestor.
    /// If neither the current container or any of its ancestors were presented modally,
    /// the value in this property is `nil`.
    ///
    /// - SeeAlso: `presentingViewController`
    public var presenting: UIViewController? {
        presentingViewController
    }

    /// The container that is presented by this container, or one of its ancestors in the container hierarchy.
    ///
    /// When you present a container modally (either explicitly or implicitly)
    /// using the `present(_:animated:completion:)` method,
    /// the container that called the method has this property set to the container that it presented.
    /// If the current container did not present another view controller modally, the value in this property is `nil`.
    ///
    /// - SeeAlso: `presentedViewController`
    public var presented: UIViewController? {
        presentedViewController
    }

    /// The stack container that is presented by this container, or one of its ancestors in the container hierarchy.
    ///
    /// Returns the value of the `presented` property casting it to the stack container type.
    ///
    /// - SeeAlso: `presented`
    public var presentedStack: UINavigationController? {
        presented as? UINavigationController
    }

    /// The tabs container that is presented by this container, or one of its ancestors in the container hierarchy.
    ///
    /// Returns the value of the `presented` property casting it to the tabs container type.
    ///
    /// - SeeAlso: `presented`
    public var presentedTabs: UITabBarController? {
        presented as? UITabBarController
    }

    /// The nearest ancestor in the container hierarchy that is a stack container.
    ///
    /// If the container or one of its ancestors is a child of a stack container,
    /// this property contains the owning stack container.
    /// This property is `nil` if the container is not embedded inside a stack container.
    ///
    /// - SeeAlso: `navigationController`
    public var stack: UINavigationController? {
        navigationController
    }

    /// The nearest ancestor in the container hierarchy that is a tabs container.
    ///
    /// If the container or one of its ancestors is a child of a tabs container,
    /// this property contains the owning tabs container.
    /// This property is `nil` if the container is not embedded inside a tabs container.
    ///
    /// - SeeAlso: `navigationController`
    public var tabs: UITabBarController? {
        tabBarController
    }

    /// The window container of this container, or `nil` if it has none.
    ///
    /// This property is `nil` if the container’s view has not yet been loaded or added to a window.
    ///
    /// - SeeAlso: `viewIfLoaded`
    public var window: UIWindow? {
        viewIfLoaded?.window
    }
}
#endif
