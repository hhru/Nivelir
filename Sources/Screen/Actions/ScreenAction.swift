import Foundation

public protocol ScreenAction {
    associatedtype Container: ScreenContainer
    associatedtype Output

    typealias Completion = (Result<Output, Error>) -> Void

    func cast<Action: ScreenAction>(
        to type: Action.Type
    ) -> Action? where Action.Container == Container

    func combine<Action: ScreenAction>(
        with other: Action
    ) -> Action? where Action.Container == Container

    func perform(
        container: Container,
        navigation: ScreenNavigation,
        completion: @escaping Completion
    )
}

extension ScreenAction {

    public func cast<Action: ScreenAction>(
        to type: Action.Type
    ) -> Action? where Action.Container == Container {
        self as? Action
    }

    public func combine<Action: ScreenAction>(
        with other: Action
    ) -> Action? where Action.Container == Container {
        nil
    }
}
