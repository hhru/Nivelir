import Foundation

/// A protocol for a factory that builds a screen module and returns its container.
///
/// This protocol provides a universal interface for building a screen module,
/// independent of its architectural pattern: MVC, VIPER, MVVM, etc.
///
/// Since the factory is the external entry point to the screen,
/// the factory is called the `Screen` for convenience.
///
///
/// External Parameters
/// ===================
///
/// Most screens require some external parameters for their configuration.
/// All such parameters should be declared as properties of the implementation of this protocol.
///
/// For example, a chat screen requires a chat ID:
///
///     class ChatViewController: UIViewController {
///
///         let chatID: Int
///
///         init(chatID: Int) {
///             self.chatID = chatID
///
///             super.init(nibName: nil, bundle: nil)
///         }
///     }
///
/// Then the implementation of its factory might look like this:
///
///     struct ChatScreen: Screen {
///
///         let chatID: Int
///
///         func build(navigator: ScreenNavigator) -> UIViewController {
///             ChatViewController(chatID: chatID)
///         }
///     }
///
/// To create this chat screen, you will need to pass the ID to the initializer:
///
///     let chatScreen = ChatScreen(chatID: 123)
///
///     navigator.navigate(fromTop: .stack) { route in
///         route.push(chatScreen)
///     }
///
///
/// Screen Key
/// ==========
///
/// Each screen has the `name` and `traits` properties, which are used to create a screen key.
/// You can use this key to create a container that can be found in the hierarchy.
/// Just conform your view controller to the `ScreenKeyedContainer` protocol and initialize it with this key.
/// See the `ScreenKeyedContainer` protocol for an example of this approach.
///
/// Default implementation of the `name` property returns type name:
///
///     let chatScreen = ChatScreen(chatID: 123)
///
///     print(chatScreen.name) // Prints: "ChatScreen"
///
/// Usually you don't need to implement the `name` property yourself.
/// If you want to distinguish between screens of the same type, implement the `traits`property.

/// For example, chat screens may be different if they have different chat IDs.
/// In this case, the `traits` property must include the chat ID:
///
///     struct ChatScreen: Screen {
///
///         let chatID: Int
///
///         var traits: Set<AnyHashable> {
///             [chatID]
///         }
///
///         func build(navigator: ScreenNavigator) -> UIViewController {
///             ChatViewController(chatID: chatID)
///         }
///     }
///
/// Then the keys for 2 screens with different chat ID will not be equal:
///
///     let firstScreen = ChatScreen(chatID: 1)
///     let secondScreen = ChatScreen(chatID: 2)
///
///     print(firstScreen.key == secondScreen.key) // Prints: "false"
///
///
/// Simple Screens
/// ==============
///
/// If your screen consists only of a view controller, implementing a factory can be an extra complication.
/// In this case, you can conform your view controller to the `Screen` protocol:
///
///     class SimpleViewController: UIViewController, Screen { }
///
/// The default implementation will return `self` in the `build(navigator:)` method,
/// and an instance of this controller can be used as a factory in navigation actions:
///
///     navigator.navigate(fromTop: .stack) { route in
///         route.push(SimpleViewController())
///     }
///
///
/// - SeeAlso: `ScreenKey`
/// - SeeAlso: `ScreenContainer`
/// - SeeAlso: `AnyScreen`
public protocol Screen: CustomStringConvertible {

    /// A type of container that the screen uses for navigation.
    ///
    /// - SeeAlso: `ScreenContainer`
    associatedtype Container: ScreenContainer

    /// Screen name.
    ///
    /// Default implementation returns type name.
    var name: String { get }

    /// Screen traits that are used to distinguish screens with the same name.
    ///
    /// Default implementation returns empty set.
    var traits: Set<AnyHashable> { get }

    /// Casts the instance to the specified type if it's possible to do so.
    ///
    /// This method is useful for casting instances of the `AnyScreen` type,
    /// because the standard `as` and `is` operators are unusable for them.
    /// For example, you can't do something like this:
    ///
    ///     let anyScreen = ChatScreen(chatID: 123).eraseToAnyScreen()
    ///
    ///     if let chatScreen = anyScreen as? ChatScreen {
    ///         print(chatScreen.chatID)
    ///     }
    ///
    /// The compiler will issue the following warning:
    ///
    ///     Cast from 'AnyScreen<UIViewController>' to unrelated type 'ChatScreen' always fails
    ///
    /// In this case, you can use the `cast(to:)` method instead:
    ///
    ///     if let chatScreen = anyScreen.cast(to: ChatScreen.self) {
    ///         print(chatScreen.chatID)
    ///     }
    ///
    /// Default implementation uses standard type casting.
    /// You don't need to implement this method yourself.
    ///
    /// - Parameter type: The type to which the instance will be cast.
    /// - Returns: An optional value of the type you are trying to cast to.
    func cast<T>(to type: T.Type) -> T?

    /// Builds the screen module and returns its container.
    ///
    /// - Parameter navigator: The navigator instance that the screen should use for its own navigation.
    /// - Returns: Container instance.
    func build(navigator: ScreenNavigator) -> Container
}

extension Screen where Self: ScreenContainer {

    public func build(navigator: ScreenNavigator) -> Self {
        self
    }
}

extension Screen {

    public var name: String {
        "\(Self.self)"
    }

    public var traits: Set<AnyHashable> {
        []
    }

    public var description: String {
        key.name
    }

    /// Screen key that can be used to search for a container in the container hierarchy.
    ///
    /// This key can be used to create a container of the `ScreenKeyedContainer` type.
    /// Default implementation creates key using the values of the `name` and `key` properties.
    ///
    /// - SeeAlso: `ScreenKeyedContainer`
    public var key: ScreenKey {
        ScreenKey(name: name, traits: traits)
    }

    public func cast<T>(to type: T.Type) -> T? {
        self as? T
    }
}
