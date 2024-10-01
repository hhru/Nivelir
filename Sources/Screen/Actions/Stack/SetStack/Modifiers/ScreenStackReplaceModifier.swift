#if canImport(UIKit)
import UIKit

public struct ScreenStackReplaceModifier<
    New: Screen
>: ScreenStackModifier where New.Container: UIViewController {

    public let screen: New

    public let description: String

    public init(screen: New) {
        self.screen = screen
        description = "Replace with \(screen)"
    }

    public func perform(
        stack: [UIViewController],
        navigator: ScreenNavigator
    ) -> [UIViewController] {
        stack.dropLast().appending(screen.build(navigator: navigator))
    }
}

extension ScreenThenable where Current: UINavigationController {

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

    public func replace<New: Screen, Route: ScreenThenable>(
        with screen: New,
        animation: ScreenStackAnimation? = .default,
        separated: Bool = false,
        route: Route
    ) -> Self where New.Container: UIViewController, Route.Root == New.Container {
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
