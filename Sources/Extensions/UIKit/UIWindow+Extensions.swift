#if canImport(UIKit)
import UIKit

extension UIWindow {

    /// The root container for the window.
    ///
    /// The root container provides the content view of the window.
    /// Assigning a container to this property (either programmatically or using Interface Builder)
    /// installs the container’s view as the content view of the window.
    /// The new content view is configured to track the window size, changing as the window size changes.
    /// If the window has an existing view hierarchy, the old views are removed before the new ones are installed.
    ///
    /// The default value of this property is `nil`.
    ///
    /// - SeeAlso: `rootViewController`
    public var root: UIViewController? {
        rootViewController
    }
}
#endif
