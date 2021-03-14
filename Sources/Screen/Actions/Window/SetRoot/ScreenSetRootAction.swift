#if canImport(UIKit)
import UIKit

public struct ScreenSetRootAction<
    New: Screen,
    Container: UIWindow
>: ScreenAction where New.Container: UIViewController {

    public typealias Output = New.Container

    public let screen: New
    public let animation: ScreenRootAnimation?

    public init(screen: New, animation: ScreenRootAnimation? = nil) {
        self.screen = screen
        self.animation = animation
    }

    public func perform(
        container: Container,
        navigation: ScreenNavigation,
        completion: @escaping Completion
    ) {
        navigation.logger?.info("Setting root of \(type(of: container)) to \(screen)")

        let root = container.root
        let newRoot = screen.build(navigator: navigation.navigator)

        container.rootViewController = newRoot

        guard let animation = animation else {
            return completion(.success(newRoot))
        }

        animation.animate(
            container: container,
            from: root,
            to: newRoot
        ) {
            completion(.success(newRoot))
        }
    }
}

extension ScreenThenable where Then: UIWindow {

    public func setRoot<New: Screen, Route: ScreenThenable>(
        to screen: New,
        animation: ScreenRootAnimation? = nil,
        route: Route
    ) -> Self where New.Container: UIViewController, Route.Root == New.Container {
        nest(
            action: ScreenSetRootAction<New, Then>(
                screen: screen,
                animation: animation
            ),
            nested: route
        )
    }

    public func setRoot<New: Screen>(
        to screen: New,
        animation: ScreenRootAnimation? = nil,
        route: (_ route: ScreenRoute<New.Container>) -> ScreenRoute<New.Container> = { $0 }
    ) -> Self where New.Container: UIViewController {
        setRoot(
            to: screen,
            animation: animation,
            route: route(.initial)
        )
    }

    public func setRoot<New: Screen, Next: ScreenContainer>(
        to screen: New,
        animation: ScreenRootAnimation? = nil,
        route: (_ route: ScreenRoute<New.Container>) -> ScreenChildRoute<New.Container, Next>
    ) -> Self where New.Container: UIViewController {
        setRoot(
            to: screen,
            animation: animation,
            route: route(.initial)
        )
    }
}
#endif
