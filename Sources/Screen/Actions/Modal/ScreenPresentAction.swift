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
        navigator: ScreenNavigator,
        completion: @escaping Completion
    ) {
        navigator.logInfo("Presenting \(screen) on \(type(of: container))")

        navigator.buildScreen(screen) { result in
            switch result {
            case let .success(output):
                container.present(output, animated: animated) {
                    completion(.success(output))
                }

            case let .failure(error):
                completion(.failure(error))
            }
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
