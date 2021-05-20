import Foundation

public struct AnyScreenAction<Container: ScreenContainer, Output>: ScreenAction {

    public typealias Output = Output

    private let box: AnyScreenActionBaseBox<Container, Output>

    public init<Wrapped: ScreenAction>(
        _ wrapped: Wrapped
    ) where Wrapped.Container == Container, Wrapped.Output == Output {
        box = AnyScreenActionBox(wrapped) { $0 }
    }

    public func cast<T>(to type: T.Type) -> T? {
        box.cast(to: type)
    }

    public func combine<Action: ScreenAction>(
        with other: Action
    ) -> Action? where Action.Container == Container {
        box.combine(with: other)
    }

    public func perform(
        container: Container,
        navigation: ScreenNavigation,
        completion: @escaping Completion
    ) {
        box.perform(
            container: container,
            navigation: navigation,
            completion: completion
        )
    }
}

extension AnyScreenAction where Output == Void {

    public init<Wrapped: ScreenAction>(
        _ wrapped: Wrapped
    ) where Wrapped.Container == Container {
        box = AnyScreenActionBox(wrapped) { result in
            result.ignoringValue()
        }
    }
}

extension ScreenAction {

    public func eraseToAnyAction() -> AnyScreenAction<Container, Output> {
        AnyScreenAction(self)
    }

    public func eraseToAnyVoidAction() -> AnyScreenAction<Container, Void> {
        AnyScreenAction(self)
    }
}
