import Foundation

public protocol ScreenAction {
    associatedtype Container: ScreenContainer
    associatedtype Output

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
