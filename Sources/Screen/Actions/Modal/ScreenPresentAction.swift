#if canImport(UIKit)
import UIKit

public struct ScreenPresentAction<
    New: Screen,
    Container: UIViewController
>: ScreenAction where New.Container: UIViewController {

    public typealias Output = New.Container

    public let screen: New
    public let animated: Bool

    public init(screen: New, animated: Bool = true) {
        self.screen = screen
        self.animated = animated
    }

    public func perform(
        container: Container,
        navigation: ScreenNavigation,
        completion: @escaping Completion
    ) {
        navigation.logger?.info("Presenting \(screen) on \(type(of: container))")

        let output = screen.build(navigator: navigation.navigator)

        container.present(output, animated: animated) {
            completion(.success(output))
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
        route: (_ route: ScreenRoute<New.Container>) -> ScreenChildRoute<New.Container, Next>
    ) -> Self where New.Container: UIViewController {
        present(
            screen,
            animated: animated,
            route: route(.initial)
        )
    }
}
#endif
