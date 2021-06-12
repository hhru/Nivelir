import Foundation

/// A screen that performs type erasure by wrapping another screen.
///
/// `AnyScreen` is a concrete implementation of `Screen` that has no significant properties of its own,
/// and passes through elements from its wrapped screen.
///
/// Use `AnyScreen` to wrap a screen whose type has details you don’t want to expose across API boundaries,
/// such as different modules.
/// When you use type erasure this way,
/// you can change the underlying screen implementation over time without affecting existing clients.
///
/// To make the constructions as compact as possible,
/// you can use aliases for `AnyScreen` with a specific type of its container:
///
/// ``` swift
/// typealias AnyModalScreen = AnyScreen<UIViewController>
/// typealias AnyStackScreen = AnyScreen<UINavigationController>
/// typealias AnyTabsScreen = AnyScreen<UITabBarController>
/// ```
///
/// You can use `eraseToAnyScreen()` method to wrap a screen with `AnyScreen`:
///
/// ``` swift
/// func chatScreen(chatID: Int) -> AnyModalScreen {
///     ChatScreen(chatID: chatID).eraseToAnyScreen()
/// }
/// ```
///
/// - SeeAlso: `Screen`
public struct AnyScreen<Container: ScreenContainer>: Screen {

    private let box: AnyScreenBaseBox<Container>

    public var name: String {
        box.name
    }

    public var traits: Set<AnyHashable> {
        box.traits
    }

    public var description: String {
        box.description
    }

    internal init<Wrapped: Screen>(
        _ wrapped: Wrapped,
        builder: @escaping (
            _ screen: Wrapped,
            _ navigator: ScreenNavigator
        ) -> Container
    ) {
        self.box = AnyScreenBox(wrapped, builder: builder)
    }

    /// Creates a type-erasing screen to wrap the provided screen.
    ///
    /// - Parameter wrapped: A screen to wrap with a type-eraser.
    public init<Wrapped: Screen>(
        _ wrapped: Wrapped
    ) where Wrapped.Container == Container {
        self.init(wrapped) { screen, navigator in
            screen.build(navigator: navigator)
        }
    }

    public func cast<T>(to type: T.Type) -> T? {
        box.cast(to: type)
    }

    public func build(navigator: ScreenNavigator) -> Container {
        box.build(navigator: navigator)
    }
}

extension Screen {

    /// Wraps this screen with a type eraser.
    ///
    /// Use `eraseToAnyScreen()` to expose an instance of `AnyScreen`, rather than this screen’s actual type.
    /// This form of type erasure preserves abstraction across API boundaries, such as different modules.
    /// When you expose your screens as the `AnyScreen` type,
    /// you can change the underlying implementation over time without affecting existing clients.
    ///
    /// - Returns: An `AnyScreen` wrapping this screen.
    ///
    /// - SeeAlso: `AnyScreen`
    public func eraseToAnyScreen() -> AnyScreen<Container> {
        AnyScreen(self)
    }
}
