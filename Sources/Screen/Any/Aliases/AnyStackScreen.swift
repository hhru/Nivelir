#if canImport(UIKit)
import UIKit

public typealias AnyStackScreen = AnyScreen<UINavigationController>

extension AnyStackScreen {

    public init<Wrapped: Screen>(
        _ wrapped: Wrapped
    ) where Wrapped.Container: UINavigationController {
        self.init(
            name: { wrapped.name },
            traits: { wrapped.traits },
            description: { wrapped.description },
            build: wrapped.build
        )
    }
}

extension Screen where Container: UINavigationController {

    public func eraseToAnyStackScreen() -> AnyStackScreen {
        AnyStackScreen(self)
    }
}
#endif
