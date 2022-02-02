#if canImport(UIKit)
import UIKit

extension UINavigationController {

    /// The root container of the stack.
    ///
    /// - SeeAlso: `viewControllers`
    public var stackRoot: UIViewController? {
        viewControllers.first
    }

    /// The container at the top of the stack.
    ///
    /// - SeeAlso: `topViewController`
    public var stackTop: UIViewController? {
        topViewController
    }

    /// The container associated with the currently visible view in the navigation interface.
    ///
    /// The currently visible container can belong either to the container at the top of the stack
    /// or to a container that was presented modally on top of the stack container itself.
    ///
    /// - SeeAlso: `visibleViewController`
    public var stackVisible: UIViewController? {
        visibleViewController
    }
}
#endif
