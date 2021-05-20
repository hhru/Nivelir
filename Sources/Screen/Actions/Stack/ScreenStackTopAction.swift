#if canImport(UIKit)
import UIKit

public struct ScreenStackTopAction<
    Container: UINavigationController,
    Output: UIViewController
>: ScreenAction {

    public init() { }

    public func perform(
        container: Container,
        navigator: ScreenNavigator,
        completion: @escaping Completion
    ) {
        guard let stackTop = container.stackTop else {
            return completion(.containerNotFound(type: UIViewController.self, for: self))
        }

        guard let output = stackTop as? Output else {
            return completion(.invalidContainer(stackTop, type: Output.self, for: self))
        }

        completion(.success(output))
    }
}

extension ScreenThenable where Then: UINavigationController {

    public var stackTop: ScreenChildRoute<Root, UIViewController> {
        stackTop(of: UIViewController.self)
    }

    public func stackTop<Output: UIViewController>(
        of type: Output.Type
    ) -> ScreenChildRoute<Root, Output> {
        nest(action: ScreenStackTopAction<Then, Output>())
    }

    public func stackTop<Route: ScreenThenable>(
        route: Route
    ) -> Self where Route.Root: UIViewController {
        nest(
            action: ScreenStackTopAction<Then, Route.Root>(),
            nested: route
        )
    }

    public func stackTop<Output: UIViewController>(
        of type: Output.Type = Output.self,
        route: (_ route: ScreenRoute<Output>) -> ScreenRoute<Output>
    ) -> Self {
        stackTop(route: route(.initial))
    }

    public func stackTop<Output: UIViewController, Next: ScreenContainer>(
        of type: Output.Type = Output.self,
        route: (_ route: ScreenRoute<Output>) -> ScreenChildRoute<Output, Next>
    ) -> Self {
        stackTop(route: route(.initial))
    }
}
#endif
