#if canImport(UIKit)
import UIKit

public struct ScreenStackRootAction<
    Container: UINavigationController,
    Output: UIViewController
>: ScreenAction {

    public init() { }

    public func perform(
        container: Container,
        navigation: ScreenNavigation,
        completion: @escaping Completion
    ) {
        guard let stackRoot = container.stackRoot else {
            return completion(.containerNotFound(type: UIViewController.self, for: self))
        }

        guard let output = stackRoot as? Output else {
            return completion(.invalidContainer(stackRoot, type: Output.self, for: self))
        }

        completion(.success(output))
    }
}

extension ScreenThenable where Then: UINavigationController {

    public var stackRoot: ScreenChildRoute<Root, UIViewController> {
        stackRoot(of: UIViewController.self)
    }

    public func stackRoot<Output: UIViewController>(
        of type: Output.Type
    ) -> ScreenChildRoute<Root, Output> {
        nest(action: ScreenStackRootAction<Then, Output>())
    }

    public func stackRoot<Route: ScreenThenable>(
        route: Route
    ) -> Self where Route.Root: UIViewController {
        nest(
            action: ScreenStackRootAction<Then, Route.Root>(),
            nested: route
        )
    }

    public func stackRoot<Output: UIViewController>(
        of type: Output.Type = Output.self,
        route: (_ route: ScreenRoute<Output>) -> ScreenRoute<Output>
    ) -> Self {
        stackRoot(route: route(.initial))
    }

    public func stackRoot<Output: UIViewController, Next: ScreenContainer>(
        of type: Output.Type = Output.self,
        route: (_ route: ScreenRoute<Output>) -> ScreenChildRoute<Output, Next>
    ) -> Self {
        stackRoot(route: route(.initial))
    }
}
#endif
