#if canImport(UIKit)
import UIKit

public typealias AnyStackScreen = AnyScreen<UINavigationController>

extension AnyStackScreen {

    public init<Wrapped: Screen>(
        _ wrapped: Wrapped
    ) where Wrapped.Container: UINavigationController {
        self.init(
            box: AnyScreenBox(
                description: { wrapped.description },
                build: { navigator, payload in
                    wrapped.build(
                        navigator: navigator,
                        payload: payload
                    )
                }
            )
        )
    }
}

extension Screen where Container: UINavigationController {

    public func eraseToAnyStackScreen() -> AnyStackScreen {
        AnyStackScreen(self)
    }
}
#endif
