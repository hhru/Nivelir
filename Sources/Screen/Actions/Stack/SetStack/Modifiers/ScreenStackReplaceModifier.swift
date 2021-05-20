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
        navigation: ScreenNavigation,
        completion: @escaping Completion
    ) {
        navigation.buildScreen(screen) { result in
            switch result {
            case let .success(output):
                completion(.success(stack.dropLast().appending(output)))

            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}

extension ScreenThenable where Then: UINavigationController {

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
        route: (_ route: ScreenRoute<New.Container>) -> ScreenRoute<New.Container>
    ) -> Self where New.Container: UIViewController {
        replace(
            with: screen,
            animation: animation,
            separated: separated,
            route: route(.initial)
        )
    }

    public func replace<New: Screen, Next: ScreenContainer>(
        with screen: New,
        animation: ScreenStackAnimation? = .default,
        separated: Bool = false,
        route: (_ route: ScreenRoute<New.Container>) -> ScreenChildRoute<New.Container, Next>
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
