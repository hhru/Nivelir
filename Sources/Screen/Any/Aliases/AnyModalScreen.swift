#if canImport(UIKit)
import UIKit

public typealias AnyModalScreen = AnyScreen<UIViewController>

extension AnyModalScreen {

    public init<Wrapped: Screen>(
        _ wrapped: Wrapped
    ) where Wrapped.Container: UIViewController {
        self.init(
            name: { wrapped.name },
            traits: { wrapped.traits },
            description: { wrapped.description },
            build: wrapped.build
        )
    }
}

extension Screen where Container: UIViewController {

    public func eraseToAnyModalScreen() -> AnyModalScreen {
        AnyModalScreen(self)
    }
}
#endif
