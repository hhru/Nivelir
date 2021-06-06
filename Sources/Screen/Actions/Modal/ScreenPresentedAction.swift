#if canImport(UIKit)
import UIKit

public struct ScreenPresentedAction<
    Container: UIViewController,
    Output: UIViewController
>: ScreenAction {

    public init() { }

    public func perform(
        container: Container,
        navigator: ScreenNavigator,
        completion: @escaping Completion
    ) {
        guard let presented = container.presented else {
            return completion(.containerNotFound(type: UIViewController.self, for: self))
        }

        guard let output = presented as? Output else {
            return completion(.containerTypeMismatch(presented, type: Output.self, for: self))
        }

        completion(.success(output))
    }
}

extension ScreenThenable where Then: UIViewController {

    public var presented: ScreenChildRoute<Root, UIViewController> {
        presented(of: UIViewController.self)
    }

    public func presented<Output: UIViewController>(
        of type: Output.Type
    ) -> ScreenChildRoute<Root, Output> {
        nest(action: ScreenPresentedAction<Then, Output>())
    }

    public func presented<Route: ScreenThenable>(
        route: Route
    ) -> Self where Route.Root: UIViewController {
        nest(
            action: ScreenPresentedAction<Then, Route.Root>(),
            nested: route
        )
    }

    public func presented<Output: UIViewController>(
        of type: Output.Type = Output.self,
        route: (_ route: ScreenRoute<Output>) -> ScreenRoute<Output>
    ) -> Self {
        presented(route: route(.initial))
    }

    public func presented<Output: UIViewController, Next: ScreenContainer>(
        of type: Output.Type = Output.self,
        route: (_ route: ScreenRoute<Output>) -> ScreenChildRoute<Output, Next>
    ) -> Self {
        presented(route: route(.initial))
    }
}
#endif
