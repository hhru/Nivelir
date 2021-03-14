#if canImport(UIKit)
import UIKit

public struct ScreenTabBarItemDecorator<Container: UIViewController>: ScreenDecorator {

    public let item: UITabBarItem

    public var payload: Any? {
        nil
    }

    public var description: String {
        "TabBarItemDecorator"
    }

    public init(item: UITabBarItem) {
        self.item = item
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

    public func withTabBarItem(_ item: UITabBarItem) -> AnyScreen<Container> {
        decorated(by: ScreenTabBarItemDecorator(item: item))
    }
}
#endif
