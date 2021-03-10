#if canImport(UIKit)
import UIKit

public typealias AnyModalScreen = AnyScreen<UIViewController>

extension AnyModalScreen {

    public init<Wrapped: Screen>(
        _ wrapped: Wrapped
    ) where Wrapped.Container: UIViewController {
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

extension Screen where Container: UIViewController {

    public func eraseToAnyModalScreen() -> AnyModalScreen {
        AnyModalScreen(self)
    }
}
#endif
