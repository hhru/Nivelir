#if canImport(UIKit)
import UIKit

public struct ScreenPresentingAction<
    Container: UIViewController,
    Output: UIViewController
>: ScreenAction {

    public init() { }

    public func perform(
        container: Container,
        navigator: ScreenNavigator,
        completion: @escaping Completion
    ) {
        guard let presenting = container.presenting else {
            return completion(.containerNotFound(type: UIViewController.self, for: self))
        }

        guard let output = presenting as? Output else {
            return completion(.invalidContainer(presenting, type: Output.self, for: self))
        }

        completion(.success(output))
    }
}

extension ScreenThenable where Then: UIViewController {

    public var presenting: ScreenChildRoute<Root, UIViewController> {
        presenting(of: UIViewController.self)
    }

    public func presenting<Output: UIViewController>(
        of type: Output.Type
    ) -> ScreenChildRoute<Root, Output> {
        nest(action: ScreenPresentingAction<Then, Output>())
    }

    public func presenting<Route: ScreenThenable>(
        route: Route
    ) -> Self where Route.Root: UIViewController {
        nest(
            action: ScreenPresentingAction<Then, Route.Root>(),
            nested: route
        )
    }

    public func presenting<Output: UIViewController>(
        of type: Output.Type = Output.self,
        route: (_ route: ScreenRoute<Output>) -> ScreenRoute<Output>
    ) -> Self {
        presenting(route: route(.initial))
    }

    public func presenting<Output: UIViewController, Next: ScreenContainer>(
        of type: Output.Type = Output.self,
        route: (_ route: ScreenRoute<Output>) -> ScreenChildRoute<Output, Next>
    ) -> Self {
        presenting(route: route(.initial))
    }
}
#endif
