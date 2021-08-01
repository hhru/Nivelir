#if canImport(UIKit)
import UIKit

public struct ScreenStackReplaceModifier<
    New: Screen
>: ScreenStackModifier where New.Container: UIViewController {

    public let screen: New

    public var description: String {
        "Replace with \(screen)"
    }

    public init(screen: New) {
        self.screen = screen
    }

    public func perform(
        in stack: [UIViewController],
        navigator: ScreenNavigator
    ) -> [UIViewController] {
        stack.dropLast().appending(screen.build(navigator: navigator))
    }
}

extension ScreenRoute where Current: UINavigationController {

    public func replace<New: Screen>(
        with screen: New,
        animation: ScreenStackAnimation? = .default,
        separated: Bool = false
    ) -> Self where New.Container: UIViewController {
        setStack(
            modifier: ScreenStackReplaceModifier(screen: screen),
            animation: animation,
            separated: separated
        )
    }

    public func replace<New: Screen, Next: ScreenContainer>(
        with screen: New,
        animation: ScreenStackAnimation? = .default,
        separated: Bool = false,
        route: ScreenRoute<New.Container, Next>
    ) -> Self where New.Container: UIViewController {
        replace(
            with: screen,
            animation: animation,
            separated: separated
        ).stackTop(
            route: route
        )
    }

    public func replace<New: Screen>(
        with screen: New,
        animation: ScreenStackAnimation? = .default,
        separated: Bool = false,
        route: (_ route: ScreenRootRoute<New.Container>) -> ScreenRouteConvertible
    ) -> Self where New.Container: UIViewController {
        replace(
            with: screen,
            animation: animation,
            separated: separated,
            route: route(.initial).route()
        )
    }
}
#endif
