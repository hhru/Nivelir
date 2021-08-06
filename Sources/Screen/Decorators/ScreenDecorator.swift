import Foundation

public protocol ScreenDecorator: CustomStringConvertible {
    associatedtype Container: ScreenContainer
    associatedtype Output: ScreenPayloadedContainer

    var payload: Any? { get }

    func build<Wrapped: Screen>(
        screen: Wrapped,
        navigator: ScreenNavigator
    ) -> Output where Wrapped.Container == Container
}

extension Screen {

    public func decorated<Decorator: ScreenDecorator>(
        by decorator: Decorator
    ) -> AnyScreen<Decorator.Output> where Container == Decorator.Container {
        AnyScreen(self) { screen, navigator in
            let container = decorator.build(
                screen: screen,
                navigator: navigator
            )

            if let payload = decorator.payload {
                container.screenPayload.store(payload)
            }

            return container
        }
    }
}
