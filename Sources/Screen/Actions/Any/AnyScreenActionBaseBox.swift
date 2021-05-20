import Foundation

internal class AnyScreenActionBaseBox<Container: ScreenContainer, Output>: ScreenAction {

    internal typealias Output = Output

    // swiftlint:disable:next unavailable_function
    internal func cast<T>(to type: T.Type) -> T? {
        fatalError("\(#function) has not been implemented")
    }

    // swiftlint:disable:next unavailable_function
    internal func combine<Action: ScreenAction>(
        with other: Action
    ) -> Action? where Action.Container == Container {
        fatalError("\(#function) has not been implemented")
    }

    // swiftlint:disable:next unavailable_function
    internal func perform(
        container: Container,
        navigator: ScreenNavigator,
        completion: @escaping Completion
    ) {
        fatalError("\(#function) has not been implemented")
    }
}
