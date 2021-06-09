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

        let newTab = screen.build(navigator: navigator)
        let tabs = container.viewControllers ?? []

        container.viewControllers = tabs.appending(newTab)

        completion(.success(newTab))
    }
}

extension ScreenRoute where Current: UITabBarController {

    public func setupTab<New: Screen, Next: ScreenContainer>(
        with screen: New,
        route: ScreenRoute<New.Container, Next>
    ) -> Self where New.Container: UIViewController {
        fold(
            action: ScreenSetupTabAction<New, Current>(screen: screen),
            nested: route
        )
    }

    public func setupTab<New: Screen>(
        with screen: New,
        route: (_ route: ScreenRootRoute<New.Container>) -> ScreenRouteConvertible = { $0 }
    ) -> Self where New.Container: UIViewController {
        setupTab(with: screen, route: route(.initial).route())
    }
}
#endif
