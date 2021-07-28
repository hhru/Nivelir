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

    public func present<New: Screen, Next: ScreenContainer>(
        _ screen: New,
        animated: Bool = true,
        route: (_ route: ScreenRoute<New.Container>) -> ScreenSubroute<New.Container, Next>
    ) -> Self where New.Container: UIViewController {
        present(
            screen,
            animated: animated,
            route: route(.initial)
        )
    }
}
#endif
