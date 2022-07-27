#if canImport(UIKit)
import UIKit

/// A screen container that can be iterated over.
///
/// This type of container is implemented by containers that can have nested containers.
/// For example, `UINavigationController` has nested containers that are stored in a stack. For `UITabBarController`, they are containers in the tab.
///
/// This protocol is used to find the specific container in nested containers.
///
/// - SeeAlso: `ScreenContainer`
public protocol ScreenIterableContainer: ScreenContainer {

    /// Returns the nested containers of a container.
    var nestedContainers: [ScreenContainer] { get }
}
#endif
