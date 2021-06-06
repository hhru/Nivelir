#if canImport(UIKit)
import UIKit

public struct ScreenStackAction<
    Container: UIViewController,
    Output: UINavigationController
>: ScreenAction {

    public init() { }

    public func perform(
        container: Container,
        navigator: ScreenNavigator,
        completion: @escaping Completion
    ) {
        guard let stack = container.stack else {
            return completion(.containerNotFound(type: UINavigationController.self, for: self))
        }

        guard let output = stack as? Output else {
            return completion(.containerTypeMismatch(stack, type: Output.self, for: self))
        }

        completion(.success(output))
    }
}

extension ScreenThenable where Then: UIViewController {

    public var stack: ScreenChildRoute<Root, UINavigationController> {
        stack(of: UINavigationController.self)
    }

    public func stack<Output: UINavigationController>(
        of type: Output.Type
    ) -> ScreenChildRoute<Root, Output> {
        nest(action: ScreenStackAction<Then, Output>())
    }

    public func stack<Route: ScreenThenable>(
        route: Route
    ) -> Self where Route.Root: UINavigationController {
        nest(
            action: ScreenStackAction<Then, Route.Root>(),
            nested: route
        )
    }

    public func stack<Output: UINavigationController>(
        of type: Output.Type = Output.self,
        route: (_ route: ScreenRoute<Output>) -> ScreenRoute<Output>
    ) -> Self {
        stack(route: route(.initial))
    }

    public func stack<Output: UINavigationController, Next: ScreenContainer>(
        of type: Output.Type = Output.self,
        route: (_ route: ScreenRoute<Output>) -> ScreenChildRoute<Output, Next>
    ) -> Self {
        stack(route: route(.initial))
    }
}
#endif
