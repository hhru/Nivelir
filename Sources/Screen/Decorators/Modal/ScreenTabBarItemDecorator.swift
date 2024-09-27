#if canImport(UIKit)
import UIKit

/// Sets the `tabBarItem` property for a container with type `UIViewController`.
public struct ScreenTabBarItemDecorator<Container: UIViewController>: ScreenDecorator {

    public let item: UITabBarItem

    public var payload: Any? {
        nil
    }

    public let description: String

    public init(item: UITabBarItem) {
        self.item = item
        description = "TabBarItemDecorator"
    }

    public func build<Wrapped: Screen>(
        screen: Wrapped,
        navigator: ScreenNavigator
    ) -> Container where Wrapped.Container == Container {
        let container = screen.build(navigator: navigator)

        container.tabBarItem = item

        return container
    }
}

extension Screen where Container: UIViewController {

    /// Sets the `tabBarItem` property for a container with type `UIViewController`.
    /// - Parameter item: `item` to set.
    /// - Returns: New `Screen` with `UITabBarItem` set to `tabBarItem`.
    @MainActor
    public func withTabBarItem(_ item: UITabBarItem) -> AnyScreen<Container> {
        decorated(by: ScreenTabBarItemDecorator(item: item))
    }
}
#endif
