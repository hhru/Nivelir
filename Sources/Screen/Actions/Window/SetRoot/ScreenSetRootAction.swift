import UIKit

public struct ScreenSetRootAction<
    New: Screen,
    Container: UIWindow
>: ScreenAction where New.Container: UIViewController {

    public typealias Output = New.Container

    public let screen: New
    public let animation: ScreenSetRootAnimation?

    public init(screen: New, animation: ScreenSetRootAnimation? = nil) {
        self.screen = screen
        self.animation = animation
    }

    public func perform(
        container: Container,
        navigation: ScreenNavigation,
        completion: @escaping Completion
    ) {
        navigation.logger?.info("Setting root of \(container) to \(screen)")

        let rootContainer = container.rootViewController
        let newRootContainer = screen.build(navigator: navigation.navigator)

        container.rootViewController = newRootContainer

        guard let animation = animation else {
            return completion(.success(newRootContainer))
        }

        animation.animate(
            container: container,
            from: rootContainer,
            to: newRootContainer
        ) {
            completion(.success(newRootContainer))
        }
    }
}

extension ScreenRoute where Container: UIWindow {

    public func setRoot<New: Screen>(
        with screen: New,
        animation: ScreenSetRootAnimation? = nil,
        route: ScreenRoute<New.Container>
    ) -> Self where New.Container: UIViewController {
        join(
            action: ScreenSetRootAction<New, Container>(
                screen: screen,
                animation: animation
            ),
            route: route
        )
    }

    public func setRoot<New: Screen>(
        with screen: New,
        animation: ScreenSetRootAnimation? = nil,
        route: (_ route: ScreenRoute<New.Container>) -> ScreenRoute<New.Container> = { $0 }
    ) -> Self where New.Container: UIViewController {
        setRoot(
            with: screen,
            animation: animation,
            route: route(.initial)
        )
    }
}
