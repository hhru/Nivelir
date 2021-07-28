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
        navigator: ScreenNavigator,
        completion: @escaping Completion
    ) {
        navigator.buildScreen(screen) { result in
            switch result {
            case let .success(output):
                completion(.success(stack.appending(output)))

            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}

extension ScreenThenable where Then: UINavigationController {

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

    public func push<New: Screen, Route: ScreenThenable>(
        _ screen: New,
        animation: ScreenStackAnimation? = .default,
        separated: Bool = false,
        route: Route
    ) -> Self where New.Container: UIViewController, Route.Root == New.Container {
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
        route: (_ route: ScreenRoute<New.Container>) -> ScreenRoute<New.Container>
    ) -> Self where New.Container: UIViewController {
        push(
            screen,
            animation: animation,
            separated: separated,
            route: route(.initial)
        )
    }

    public func push<New: Screen, Next: ScreenContainer>(
        _ screen: New,
        animation: ScreenStackAnimation? = .default,
        separated: Bool = false,
        route: (_ route: ScreenRoute<New.Container>) -> ScreenSubroute<New.Container, Next>
    ) -> Self where New.Container: UIViewController {
        push(
            screen,
            animation: animation,
            separated: separated,
            route: route(.initial)
        )
    }
}
#endif
