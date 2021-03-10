import Foundation

public struct AnyScreen<Container: ScreenContainer>: Screen {

    private let box: AnyScreenBox<Container>

    public var description: String {
        box.description()
    }

    internal init(box: AnyScreenBox<Container>) {
        self.box = box
    }

    public init<Wrapped: Screen>(
        _ wrapped: Wrapped
    ) where Wrapped.Container == Container {
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

    public func build(navigator: ScreenNavigator, payload: Any?) -> Container {
        box.build(navigator, payload)
    }
}

extension Screen {

    public func eraseToAnyScreen() -> AnyScreen<Container> {
        AnyScreen(self)
    }
}
