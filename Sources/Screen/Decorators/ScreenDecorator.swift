import Foundation

/// The `ScreenDecorator` allows you to decorate a `Screen` by complementing or modifying its container.
/// When decorating, the container type can be changed to the one specified in `associatedtype Output`.
///
/// An example of decorating a chat screen that wraps a container in a UINavigationController.
///
/// ```swift
/// let chatScreen = ChatScreen(chatID: 1)
/// let stackScreen = chatScreen.withStackContainer()
/// ```
///
/// Now the chat screen is placed in a stack of type `UINavigationController` as the root.
/// After that it will be possible to perform actions to modify the stack:
///
/// ```swift
/// navigator.navigate(from: stackScreen) { route in
///     route.push(ChatScreen(chatID: 2))
/// }
/// ```
///
/// - SeeAlso: `Screen`
public protocol ScreenDecorator: CustomStringConvertible {

    /// The type of screen container to be decorated.
    ///
    /// - SeeAlso: `ScreenContainer`
    associatedtype Container: ScreenContainer

    /// A new type of container, returned as a result of the decoration.
    /// `Output` and `Conatiner` types can be the same when only modifying a container without changing its type.
    ///
    /// - SeeAlso: `ScreenPayloadedContainer`
    associatedtype Output: ScreenPayloadedContainer

    /// `payload` is used to store data along with the decorated screen.
    /// The data is deleted when the screen is released from memory.
    /// This can be useful for storing **delegate** properties that are needed when displaying the screen.
    /// See `ScreenModalStyleDecorator` for an example of how to use it.
    ///
    /// - SeeAlso: `ScreenPayload`
    var payload: Any? { get }

    /// Build of the wrapped container.
    /// - Parameters:
    ///   - screen: Screen with the container type specified in `associatedtype Container`.
    ///   - navigator: The navigator instance that the screen should use for its own navigation.
    /// - Returns: New or modified container instance with type `Output`
    func build<Wrapped: Screen>(
        screen: Wrapped,
        navigator: ScreenNavigator
    ) -> Output where Wrapped.Container == Container
}

extension Screen {

    /// Decorating the screen with the decorator.
    /// - Parameter decorator: A decorator instance that implements `ScreenDecorator`.
    /// - Returns: New `Screen` with the container type specified in the `Output` of decorator.
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
