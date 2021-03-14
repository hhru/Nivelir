#if canImport(UIKit)
import UIKit

public typealias AnyTabsScreen = AnyScreen<UITabBarController>

extension AnyTabsScreen where Container == UITabBarController {

    public init<Wrapped: Screen>(
        _ wrapped: Wrapped
    ) where Wrapped.Container: UITabBarController {
        self.init(
            name: { wrapped.name },
            traits: { wrapped.traits },
            description: { wrapped.description },
            build: wrapped.build
        )
    }
}

extension Screen where Container: UITabBarController {

    public func eraseToAnyTabsScreen() -> AnyTabsScreen {
        AnyTabsScreen(self)
    }
}
#endif
