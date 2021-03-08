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
        navigation: ScreenNavigation
    ) throws -> [UIViewController] {
        stack
            .dropLast()
            .appending(screen.build(navigator: navigation.navigator))
    }
}

extension ScreenRoute where Container: UINavigationController {

    public func replace<New: Screen>(
        with screen: New,
        animation: ScreenStackAnimation? = .default,
        separated: Bool = false,
        route: ScreenRoute<New.Container>
    ) -> Self where New.Container: UIViewController {
        let setStackRoute = setStack(
            modifier: ScreenStackReplaceModifier(screen: screen),
            animation: animation,
            separated: separated
        )

        return route.isEmpty
            ? setStackRoute
            : setStackRoute.stackTop(
                of: New.Container.self,
                route: route
            )
    }

    public func replace<New: Screen>(
        with screen: New,
        animation: ScreenStackAnimation? = .default,
        separated: Bool = false,
        route: (_ route: ScreenRoute<New.Container>) -> ScreenRoute<New.Container> = { $0 }
    ) -> Self where New.Container: UIViewController {
        replace(
            with: screen,
            animation: animation,
            separated: separated,
            route: route(.initial)
        )
    }
}
#endif
