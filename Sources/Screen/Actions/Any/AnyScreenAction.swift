import Foundation

public struct AnyScreenAction<Container: ScreenContainer, Output>:
    ScreenAction,
    CustomStringConvertible {

    public typealias Output = Output

    private let box: AnyScreenActionBaseBox<Container, Output>

    public var description: String {
        box.description
    }

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
    ) -> AnyScreenAction<Container, Void>? {
        box.combine(with: other)
    }

    public func perform(
        container: Container,
        navigator: ScreenNavigator,
        completion: @escaping Completion
    ) {
        box.perform(
            container: container,
            navigator: navigator,
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
