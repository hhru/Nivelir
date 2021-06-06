#if canImport(UIKit)
import UIKit

public struct ScreenSelectedTabAction<
    Container: UITabBarController,
    Output: UIViewController
>: ScreenAction {

    public init() { }

    public func perform(
        container: Container,
        navigator: ScreenNavigator,
        completion: @escaping Completion
    ) {
        guard let selectedTab = container.selectedTab else {
            return completion(.containerNotFound(type: UIViewController.self, for: self))
        }

        guard let output = selectedTab as? Output else {
            return completion(.containerTypeMismatch(selectedTab, type: Output.self, for: self))
        }

        completion(.success(output))
    }
}

extension ScreenThenable where Then: UITabBarController {

    public var selectedTab: ScreenChildRoute<Root, UIViewController> {
        selectedTab(of: UIViewController.self)
    }

    public func selectedTab<Output: UIViewController>(
        of type: Output.Type
    ) -> ScreenChildRoute<Root, Output> {
        nest(action: ScreenSelectedTabAction<Then, Output>())
    }

    public func selectedTab<Route: ScreenThenable>(
        route: Route
    ) -> Self where Route.Root: UIViewController {
        nest(
            action: ScreenSelectedTabAction<Then, Route.Root>(),
            nested: route
        )
    }

    public func selectedTab<Output: UIViewController>(
        of type: Output.Type = Output.self,
        route: (_ route: ScreenRoute<Output>) -> ScreenRoute<Output>
    ) -> Self {
        selectedTab(route: route(.initial))
    }

    public func selectedTab<Output: UIViewController, Next: ScreenContainer>(
        of type: Output.Type = Output.self,
        route: (_ route: ScreenRoute<Output>) -> ScreenChildRoute<Output, Next>
    ) -> Self {
        selectedTab(route: route(.initial))
    }
}
#endif
