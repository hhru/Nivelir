import Foundation

/// A protocol representing the navigation action that is performed in the screen container.
public protocol ScreenAction {

    /// A type of container that the action uses for navigation.
    ///
    /// - SeeAlso: `ScreenContainer`
    associatedtype Container: ScreenContainer

    /// The type of value returned by the action.
    associatedtype Output

    /// Alias for the closure that is called after the action is completed.
    typealias Completion = (Result<Output, Error>) -> Void

    func cast<T>(to type: T.Type) -> T?

    func combine<Action: ScreenAction>(
        with other: Action
    ) -> AnyScreenAction<Container, Void>?

    func perform(
        container: Container,
        navigator: ScreenNavigator,
        completion: @escaping Completion
    )
}

extension ScreenAction {

    public func cast<T>(to type: T.Type) -> T? {
        self as? T
    }

    public func combine<Action: ScreenAction>(
        with other: Action
    ) -> AnyScreenAction<Container, Void>? {
        nil
    }
}
