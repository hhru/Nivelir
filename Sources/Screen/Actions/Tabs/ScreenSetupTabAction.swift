#if canImport(UIKit)
import UIKit

public struct ScreenSetupTabAction<
    New: Screen,
    Container: UITabBarController
>: ScreenAction where New.Container: UIViewController {

    public typealias Output = New.Container

    public let screen: New

    public init(screen: New) {
        self.screen = screen
    }

    public func perform(
        container: Container,
        navigator: ScreenNavigator,
        completion: @escaping Completion
    ) {
        navigator.logInfo("Setting up new tab in \(type(of: container)) with \(screen)")

        navigator.buildScreen(screen) { result in
            switch result {
            case let .success(output):
                let tabs = container.viewControllers ?? []

                container.viewControllers = tabs.appending(output)

                completion(.success(output))

            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}

extension ScreenThenable where Then: UITabBarController {

    public func setupTab<New: Screen, Route: ScreenThenable>(
        with screen: New,
        route: Route
    ) -> Self where New.Container: UIViewController, Route.Root == New.Container {
        nest(
            action: ScreenSetupTabAction<New, Then>(screen: screen),
            nested: route
        )
    }

    public func setupTab<New: Screen>(
        with screen: New,
        route: (_ route: ScreenRoute<New.Container>) -> ScreenRoute<New.Container> = { $0 }
    ) -> Self where New.Container: UIViewController {
        setupTab(with: screen, route: route(.initial))
    }

    public func setupTab<New: Screen, Next: ScreenContainer>(
        with screen: New,
        route: (_ route: ScreenRoute<New.Container>) -> ScreenSubroute<New.Container, Next>
    ) -> Self where New.Container: UIViewController {
        setupTab(with: screen, route: route(.initial))
    }
}
#endif
