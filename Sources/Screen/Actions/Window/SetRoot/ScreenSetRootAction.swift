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
        navigator: ScreenNavigator,
        completion: @escaping Completion
    ) {
        navigator.logInfo("Setting root of \(type(of: container)) to \(screen)")

        let newRoot = screen.build(navigator: navigator)
        let root = container.root

        container.rootViewController = newRoot

        guard let animation = self.animation else {
            return completion(.success(newRoot))
        }

        animation.animate(container: container, from: root, to: newRoot) {
            completion(.success(newRoot))
        }
    }
}

extension ScreenRoute where Current: UIWindow {

    public func setRoot<New: Screen, Next: ScreenContainer>(
        to screen: New,
        animation: ScreenRootAnimation? = nil,
        route: ScreenRoute<New.Container, Next>
    ) -> Self where New.Container: UIViewController {
        fold(
            action: ScreenSetRootAction<New, Current>(
                screen: screen,
                animation: animation
            ),
            nested: route
        )
    }

    public func setRoot<New: Screen, Next: ScreenContainer>(
        to screen: New,
        animation: ScreenRootAnimation? = nil,
        route: (_ route: ScreenRootRoute<New.Container>) -> ScreenRoute<New.Container, Next>
    ) -> Self where New.Container: UIViewController {
        setRoot(
            to: screen,
            animation: animation,
            route: route(.initial)
        )
    }

    public func setRoot<New: Screen>(
        to screen: New,
        animation: ScreenRootAnimation? = nil
    ) -> Self where New.Container: UIViewController {
        setRoot(to: screen, animation: animation) { $0 }
    }
}
#endif
