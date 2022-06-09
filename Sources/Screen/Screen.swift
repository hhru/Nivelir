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
/// ``` swift
/// class ChatViewController: UIViewController {
///
///     let chatID: Int
///
///     init(chatID: Int) {
///         self.chatID = chatID
///
///         super.init(nibName: nil, bundle: nil)
///     }
/// }
/// ```
///
/// Then the implementation of its factory might look like this:
///
/// ``` swift
/// struct ChatScreen: Screen {
///
///     let chatID: Int
///
///     func build(navigator: ScreenNavigator) -> UIViewController {
///         ChatViewController(chatID: chatID)
///     }
/// }
/// ```
///
/// To create this chat screen, you will need to pass the ID to the initializer:
///
/// ``` swift
/// let chatScreen = ChatScreen(chatID: 123)
///
/// navigator.navigate(fromTop: .stack) { route in
///     route.push(chatScreen)
/// }
/// ```
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
/// ``` swift
/// let chatScreen = ChatScreen(chatID: 123)
///
/// print(chatScreen.name) // Prints: "ChatScreen"
/// ```
///
/// Usually you don't need to implement the `name` property yourself.
/// If you want to distinguish between screens of the same type, implement the `traits`property.

/// For example, chat screens may be different if they have different chat IDs.
/// In this case, the `traits` property must include the chat ID:
///
/// ``` swift
/// struct ChatScreen: Screen {
///
///     let chatID: Int
///
///     var traits: Set<AnyHashable> {
///         [chatID]
///     }
///
///     func build(navigator: ScreenNavigator) -> UIViewController {
///         ChatViewController(chatID: chatID)
///     }
/// }
/// ```
///
/// Then the keys for 2 screens with different chat ID will not be equal:
///
/// ``` swift
/// let firstScreen = ChatScreen(chatID: 1)
/// let secondScreen = ChatScreen(chatID: 2)
///
/// print(firstScreen.key == secondScreen.key) // Prints: "false"
/// ```
///
/// Simple Screens
/// ==============
///
/// If your screen consists only of a view controller, implementing a factory can be an extra complication.
/// In this case, you can conform your view controller to the `Screen` protocol:
///
/// ``` swift
/// class SimpleViewController: UIViewController, Screen { }
/// ```
///
/// The default implementation will return `self` in the `build(navigator:)` method,
/// and an instance of this controller can be used as a factory in navigation:
///
/// ``` swift
/// navigator.navigate(fromTop: .stack) { route in
///     route.push(SimpleViewController())
/// }
/// ```
///
/// - SeeAlso: `ScreenKey`
/// - SeeAlso: `ScreenContainer`
/// - SeeAlso: `AnyScreen`
public protocol Screen: CustomStringConvertible {

    /// A type of container that the screen uses for navigation.
    ///
    /// - SeeAlso: `ScreenContainer`
    associatedtype Container: ScreenContainer

    /// A type of observer that the screen uses to send events.
    ///
    /// - SeeAlso: `ScreenObservation`
    associatedtype Observer

    /// Screen name.
    ///
    /// Default implementation returns type name.
    var name: String { get }

    /// Screen traits that are used to distinguish screens with the same name.
    ///
    /// Default implementation returns empty set.
    var traits: Set<AnyHashable> { get }

    /// Builds the screen module and returns its container.
    ///
    /// - Parameter navigator: The navigator instance that the screen should use for its own navigation.
    /// - Returns: Container instance.
    ///
    /// - SeeAlso: `ScreenNavigator`
    func build(navigator: ScreenNavigator) -> Container

    /// Builds the screen module and returns its container.
    ///
    /// - Parameters:
    ///   - navigator: The navigator instance that the screen should use for its own navigation.
    ///   - observation: An instance of `ScreenObservation` that the screen should use to send events.
    /// - Returns: Container instance.
    ///
    /// - SeeAlso: `ScreenNavigator`
    /// - SeeAlso: `ScreenObservation`
    func build(
        navigator: ScreenNavigator,
        observation: ScreenObservation<Observer>
    ) -> Container
}

extension Screen where Self: ScreenContainer, Observer == Never {

    public func build(navigator: ScreenNavigator) -> Self {
        self
    }
}

extension Screen where Observer == Never {

    public func build(
        navigator: ScreenNavigator,
        observation: ScreenObservation<Never>
    ) -> Container {
        build(navigator: navigator)
    }
}

extension Screen {

    public func build(navigator: ScreenNavigator) -> Container {
        let observation = navigator.observation(of: Observer.self)

        let container = build(
            navigator: navigator,
            observation: observation
        )

        observation.associate(with: container)

        return container
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
        "\(key)"
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
}
