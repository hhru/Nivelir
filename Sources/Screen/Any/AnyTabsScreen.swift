import UIKit

public typealias AnyTabsScreen = AnyScreen<UITabBarController>

extension AnyTabsScreen where Container == UITabBarController {

    public init<Wrapped: Screen>(
        _ wrapped: Wrapped
    ) where Wrapped.Container: UITabBarController {
        self.init(
            box: AnyScreenBox(
                key: { wrapped.key },
                description: { wrapped.description },
                build: { navigator, payload in
                    wrapped.build(
                        navigator: navigator,
                        associating: payload
                    )
                }
            )
        )
    }
}

extension Screen where Container: UITabBarController {

    public func eraseToAnyTabsScreen() -> AnyTabsScreen {
        AnyTabsScreen(self)
    }
}
