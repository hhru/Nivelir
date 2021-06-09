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

        let presented = screen.build(navigator: navigator)

        container.present(presented, animated: animated) {
            completion(.success(presented))
        }
    }
}

extension ScreenRoute where Current: UIViewController {

    public func present<New: Screen, Next: ScreenContainer>(
        _ screen: New,
        animated: Bool = true,
        route: ScreenRoute<New.Container, Next>
    ) -> Self where New.Container: UIViewController {
        fold(
            action: ScreenPresentAction<New, Current>(
                screen: screen,
                animated: animated
            ),
            nested: route
        )
    }

    public func present<New: Screen>(
        _ screen: New,
        animated: Bool = true,
        route: (_ route: ScreenRootRoute<New.Container>) -> ScreenRouteConvertible = { $0 }
    ) -> Self where New.Container: UIViewController {
        present(
            screen,
            animated: animated,
            route: route(.initial).route()
        )
    }
}
#endif
