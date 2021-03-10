import Foundation

public protocol ScreenDecorator {
    associatedtype Container: ScreenContainer
    associatedtype Output: ScreenContainer

    var payload: Any? { get }

    func buildDecorated<Wrapped: Screen>(
        screen: Wrapped,
        navigator: ScreenNavigator,
        payload: Any?
    ) -> Output where Wrapped.Container == Container
}
