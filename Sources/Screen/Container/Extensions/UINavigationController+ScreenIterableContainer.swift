#if canImport(UIKit)
import UIKit

extension UINavigationController: ScreenIterableContainer {

    /// Returns nested containers from the navigation stack.
    ///
    /// - SeeAlso: `viewControllers`
    public var nestedContainers: [ScreenContainer] {
        viewControllers
    }
}
#endif
