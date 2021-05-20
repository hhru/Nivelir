import Foundation

public struct AnyScreen<Container: ScreenContainer>: Screen {

    private let box: AnyScreenBaseBox<Container>

    public var name: String {
        box.name
    }

    public var traits: Set<AnyHashable> {
        box.traits
    }

    public var description: String {
        box.description
    }

    internal init<Wrapped: Screen>(
        _ wrapped: Wrapped,
        builder: @escaping (
            _ screen: Wrapped,
            _ navigator: ScreenNavigator
        ) -> Container
    ) {
        self.box = AnyScreenBox(wrapped, builder: builder)
    }

    public init<Wrapped: Screen>(
        _ wrapped: Wrapped
    ) where Wrapped.Container == Container {
        self.init(wrapped) { screen, navigator in
            screen.build(navigator: navigator)
        }
    }

    public func cast<T>(to type: T.Type) -> T? {
        box.cast(to: type)
    }

    public func build(navigator: ScreenNavigator) -> Container {
        box.build(navigator: navigator)
    }
}

extension Screen {

    public func eraseToAnyScreen() -> AnyScreen<Container> {
        AnyScreen(self)
    }
}
