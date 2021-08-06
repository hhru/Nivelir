import Foundation

/// An action that performs type erasure by wrapping another action.
///
/// `AnyScreenAction` is a concrete implementation of `ScreenAction` that has no significant properties of its own,
/// and passes through elements from its wrapped action.
///
/// Use `AnyScreenAction` to wrap an actions
/// whose type has details you don’t want to expose across API boundaries, such as different modules.
/// When you use type erasure this way,
/// you can change the underlying acrtion implementation over time without affecting existing clients.
///
/// You can use `eraseToAnyAction()` and `eraseToAnyVoidAction()`methods
/// to wrap an action with `AnyScreenAction`.
///
/// - SeeAlso: `ScreenAction`
public struct AnyScreenAction<Container: ScreenContainer, Output>:
    ScreenAction,
    CustomStringConvertible {

    public typealias Output = Output

    private let box: AnyScreenActionBaseBox<Container, Output>

    public var description: String {
        box.description
    }

    /// Creates a type-erasing action to wrap the provided action.
    ///
    /// - Parameter wrapped: An action to wrap with a type-eraser.
    public init<Wrapped: ScreenAction>(
        _ wrapped: Wrapped
    ) where Wrapped.Container == Container, Wrapped.Output == Output {
        box = AnyScreenActionBox(wrapped) { $0 }
    }

    public func cast<Action: ScreenAction>(to type: Action.Type) -> Action? {
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

    /// Wraps this action with a type eraser.
    ///
    /// Use `eraseToAnyAction()` to expose an instance of `AnyScreenAction`, rather than this action’s actual type.
    /// This form of type erasure preserves abstraction across API boundaries, such as different modules.
    /// When you expose your actions as the `AnyScreenAction` type,
    /// you can change the underlying implementation over time without affecting existing clients.
    ///
    /// - Returns: An `AnyScreenAction` wrapping this action.
    ///
    /// - SeeAlso: `AnyScreenAction`
    public func eraseToAnyAction() -> AnyScreenAction<Container, Output> {
        AnyScreenAction(self)
    }

    /// Wraps this action with a type eraser, ignoring the output type of the action.
    ///
    /// Use `eraseToAnyVoidAction()` to expose an instance of `AnyScreenAction`,
    /// rather than this action’s actual type.
    /// This form of type erasure preserves abstraction across API boundaries, such as different modules.
    /// When you expose your actions as the `AnyScreenAction` type,
    /// you can change the underlying implementation over time without affecting existing clients.
    ///
    /// - Returns: An `AnyScreenAction` wrapping this action.
    ///
    /// - SeeAlso: `AnyScreenAction`
    public func eraseToAnyVoidAction() -> AnyScreenAction<Container, Void> {
        AnyScreenAction(self)
    }
}
