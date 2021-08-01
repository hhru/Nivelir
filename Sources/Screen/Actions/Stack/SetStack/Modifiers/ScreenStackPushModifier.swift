#if canImport(UIKit)
import UIKit

public struct ScreenStackPushModifier<
    New: Screen
>: ScreenStackModifier where New.Container: UIViewController {

    public let screen: New

    public var description: String {
        "Push \(screen)"
    }

    public init(screen: New) {
        self.screen = screen
    }

    public func perform(
        in stack: [UIViewController],
        navigator: ScreenNavigator
    ) -> [UIViewController] {
        stack.appending(screen.build(navigator: navigator))
    }
}

extension ScreenRoute where Current: UINavigationController {

    public func push<New: Screen>(
        _ screen: New,
        animation: ScreenStackAnimation? = .default,
        separated: Bool = false
    ) -> Self where New.Container: UIViewController {
        setStack(
            modifier: ScreenStackPushModifier(screen: screen),
            animation: animation,
            separated: separated
        )
    }

    public func push<New: Screen, Next: ScreenContainer>(
        _ screen: New,
        animation: ScreenStackAnimation? = .default,
        separated: Bool = false,
        route: ScreenRoute<New.Container, Next>
    ) -> Self where New.Container: UIViewController {
        push(
            screen,
            animation: animation,
            separated: separated
        ).stackTop(
            route: route
        )
    }

    public func push<New: Screen>(
        _ screen: New,
        animation: ScreenStackAnimation? = .default,
        separated: Bool = false,
        route: (_ route: ScreenRootRoute<New.Container>) -> ScreenRouteConvertible
    ) -> Self where New.Container: UIViewController {
        push(
            screen,
            animation: animation,
            separated: separated,
            route: route(.initial).route()
        )
    }
}
#endif
