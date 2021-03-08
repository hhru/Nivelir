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
        navigation: ScreenNavigation,
        completion: @escaping Completion
    ) {
        navigation.logger?.info("Setting up new tab in \(container) with \(screen)")

        let tabs = container.viewControllers ?? []
        let output = screen.build(navigator: navigation.navigator)

        container.viewControllers = tabs.appending(output)

        completion(.success(output))
    }
}

extension ScreenRoute where Container: UITabBarController {

    public func setupTab<New: Screen>(
        with screen: New,
        route: ScreenRoute<New.Container>
    ) -> Self where New.Container: UIViewController {
        join(
            action: ScreenSetupTabAction<New, Container>(screen: screen),
            route: route
        )
    }

    public func setupTab<New: Screen>(
        with screen: New,
        route: (_ route: ScreenRoute<New.Container>) -> ScreenRoute<New.Container> = { $0 }
    ) -> Self where New.Container: UIViewController {
        setupTab(
            with: screen,
            route: route(.initial)
        )
    }
}
