#if canImport(UIKit)
import UIKit

/// Presents a screen modally.
public struct ScreenPresentAction<
    New: Screen,
    Container: UIViewController
>: ScreenAction where New.Container: UIViewController {

    /// The type of value returned by the action.
    public typealias Output = New.Container

    /// The screen to display over the current container’s content.
    ///
    /// - SeeAlso: `Screen`
    public let screen: New

    /// A Boolean value indicating whether the transition will be animated.
    public let animated: Bool

    /// Creates action.
    ///
    /// - Parameters:
    ///   - screen: The screen to display over the current container’s content.
    ///   - animated: A Boolean value indicating whether the transition will be animated.
    ///               The default value is `false`.
    public init(screen: New, animated: Bool = true) {
        self.screen = screen
        self.animated = animated
    }

    public func perform(
        container: Container,
        navigator: ScreenNavigator,
        completion: @escaping Completion
    ) {
        navigator.logInfo("Presenting \(screen) on \(type(of: container))")

        let presented = screen.build(navigator: navigator)

        container.present(presented, animated: animated) {
            completion(.success(presented))
        }
    }
}

extension ScreenThenable where Then: UIViewController {

    /// Presents a screen modally and performs a route on the screen container.
    ///
    /// Usage examples
    /// ==============
    ///
    /// - Presents a chat screen modally, then shows an error message on its container:
    ///
    /// ``` swift
    /// let nestedRoute = ScreenModalRoute
    ///     .initial
    ///     .showAlert(.somethingWentWrong)
    ///
    /// navigator.navigate(from: container) { route in
    ///     route.present(ChatScreen(chatID: chatID), route: nestedRoute)
    /// }
    /// ```
    ///
    /// - Presents a chat screen, then shows an error message on the top container
    /// in the hierarchy of the created screen container:
    ///
    /// ``` swift
    /// let nestedSubroute = ScreenModalRoute
    ///     .initial
    ///     .top(.container)
    ///     .showAlert(.somethingWentWrong)
    ///
    /// navigator.navigate(from: container) { route in
    ///     route.present(ChatScreen(chatID: chatID), route: nestedSubroute)
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - screen: The screen to display over the current container’s content.
    ///   - animated: Pass `true` to animate the transition or `false`
    ///               if you do not want the transition to be animated.
    ///               The default value is `false`.
    ///   - route: The route that will be performed in the presented screen container.
    /// - Returns: An instance containing the new navigation action.
    ///
    /// - SeeAlso: `Screen`
    public func present<New: Screen, Route: ScreenThenable>(
        _ screen: New,
        animated: Bool = true,
        route: Route
    ) -> Self where New.Container: UIViewController, Route.Root == New.Container {
        nest(
            action: ScreenPresentAction<New, Then>(
                screen: screen,
                animated: animated
            ),
            nested: route
        )
    }

    /// Presents a screen modally and performs a route on the screen container.
    ///
    /// Usage examples
    /// ==============
    ///
    /// - Presents a chat screen modally:
    ///
    /// ``` swift
    /// navigator.navigate(from: container) { route in
    ///     route.present(ChatScreen(chatID: chatID))
    /// }
    /// ```
    ///
    /// - Presents a chat screen modally, then shows an error message on its container:
    ///
    /// ``` swift
    /// navigator.navigate(from: self) { route in
    ///     route.present(ChatScreen(chatID: chatID)) { route in
    ///         route.showAlert(.somethingWentWrong)
    ///     }
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - screen: The screen to display over the current container’s content.
    ///   - animated: Pass `true` to animate the transition or `false`
    ///               if you do not want the transition to be animated.
    ///               The default value is `false`.
    ///   - route: The closure that should return the route
    ///            that will be performed in the presented screen container.
    ///            The default value returns empty route.
    /// - Returns: An instance containing the new navigation action.
    ///
    /// - SeeAlso: `Screen`
    /// - SeeAlso: `ScreenRoute`
    public func present<New: Screen>(
        _ screen: New,
        animated: Bool = true,
        route: (_ route: ScreenRoute<New.Container>) -> ScreenRoute<New.Container> = { $0 }
    ) -> Self where New.Container: UIViewController {
        present(
            screen,
            animated: animated,
            route: route(.initial)
        )
    }

    /// Presents a screen modally and performs a subroute on the screen container.
    ///
    /// Usage examples
    /// ==============
    ///
    /// - Presents a chat screen, then shows an error message on the top container
    /// in the hierarchy of the created screen:
    ///
    /// ``` swift
    /// navigator.navigate(from: container) { route in
    ///     route.present(ChatScreen(chatID: chatID)) { route in
    ///         route
    ///             .top(.container)
    ///             .showAlert(.somethingWentWrong)
    ///     }
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - screen: The screen to display over the current container’s content.
    ///   - animated: Pass `true` to animate the transition or `false`
    ///               if you do not want the transition to be animated.
    ///               The default value is `false`.
    ///   - subroute: The closure that should return the subroute
    ///               that will be performed in the presented screen container.
    ///               The default value returns empty route.
    /// - Returns: An instance containing the new navigation action.
    ///
    /// - SeeAlso: `Screen`
    /// - SeeAlso: `ScreenSubroute`
    public func present<New: Screen, Next: ScreenContainer>(
        _ screen: New,
        animated: Bool = true,
        subroute: (_ route: ScreenRoute<New.Container>) -> ScreenSubroute<New.Container, Next>
    ) -> Self where New.Container: UIViewController {
        present(
            screen,
            animated: animated,
            route: subroute(.initial)
        )
    }
}
#endif
