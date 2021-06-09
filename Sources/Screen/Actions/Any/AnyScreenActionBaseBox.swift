import Foundation

internal class AnyScreenActionBaseBox<Container: ScreenContainer, Output>:
    ScreenAction,
    CustomStringConvertible {

    internal typealias Output = Output

    internal var description: String {
        fatalError("\(#function) has not been implemented")
    }

    // swiftlint:disable:next unavailable_function
    internal func cast<T>(to type: T.Type) -> T? {
        fatalError("\(#function) has not been implemented")
    }

    // swiftlint:disable:next unavailable_function
    internal func combine<Action: ScreenAction>(
        with other: Action
    ) -> AnyScreenAction<Container, Void>? {
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
