#if canImport(UIKit)
import UIKit

public struct ScreenRootAction<
    Container: UIWindow,
    Output: UIViewController
>: ScreenAction {

    public init() { }

    public func perform(
        container: Container,
        navigator: ScreenNavigator,
        completion: @escaping Completion
    ) {
        guard let root = container.root else {
            return completion(.containerNotFound(type: UIViewController.self, for: self))
        }

        guard let output = root as? Output else {
            return completion(.invalidContainer(root, type: Output.self, for: self))
        }

        completion(.success(output))
    }
}

extension ScreenThenable where Then: UIWindow {

    public var root: ScreenChildRoute<Root, UIViewController> {
        root(of: UIViewController.self)
    }

    public func root<Output: UIViewController>(
        of type: Output.Type = Output.self
    ) -> ScreenChildRoute<Root, Output> {
        nest(action: ScreenRootAction<Then, Output>())
    }

    public func root<Route: ScreenThenable>(
        route: Route
    ) -> Self where Route.Root: UIViewController {
        nest(
            action: ScreenRootAction<Then, Route.Root>(),
            nested: route
        )
    }

    public func root<Output: UIViewController>(
        of type: Output.Type = Output.self,
        route: (_ route: ScreenRoute<Output>) -> ScreenRoute<Output>
    ) -> Self {
        root(route: route(.initial))
    }

    public func root<Output: UIViewController, Next: ScreenContainer>(
        of type: Output.Type = Output.self,
        route: (_ route: ScreenRoute<Output>) -> ScreenChildRoute<Output, Next>
    ) -> Self {
        root(route: route(.initial))
    }
}
#endif
