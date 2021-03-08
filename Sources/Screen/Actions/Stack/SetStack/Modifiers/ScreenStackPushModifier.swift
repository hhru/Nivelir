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
        navigation: ScreenNavigation
    ) throws -> [UIViewController] {
        stack.appending(screen.build(navigator: navigation.navigator))
    }
}

extension ScreenRoute where Container: UINavigationController {

    public func push<New: Screen>(
        _ screen: New,
        animation: ScreenStackAnimation? = .default,
        separated: Bool = false,
        route: ScreenRoute<New.Container>
    ) -> Self where New.Container: UIViewController {
        let setStackRoute = setStack(
            modifier: ScreenStackPushModifier(screen: screen),
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

    public func push<New: Screen>(
        _ screen: New,
        animation: ScreenStackAnimation? = .default,
        separated: Bool = false,
        route: (_ route: ScreenRoute<New.Container>) -> ScreenRoute<New.Container> = { $0 }
    ) -> Self where New.Container: UIViewController {
        push(
            screen,
            animation: animation,
            separated: separated,
            route: route(.initial)
        )
    }
}
