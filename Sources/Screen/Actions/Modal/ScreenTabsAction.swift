#if canImport(UIKit)
import UIKit

public struct ScreenTabsAction<
    Container: UIViewController,
    Output: UITabBarController
>: ScreenAction {

    public init() { }

    public func perform(
        container: Container,
        navigation: ScreenNavigation,
        completion: @escaping Completion
    ) {
        guard let tabs = container.tabs else {
            return completion(.containerNotFound(type: UITabBarController.self, for: self))
        }

        guard let output = tabs as? Output else {
            return completion(.invalidContainer(tabs, type: Output.self, for: self))
        }

        completion(.success(output))
    }
}

extension ScreenThenable where Then: UIViewController {

    public var tabs: ScreenChildRoute<Root, UITabBarController> {
        tabs(of: UITabBarController.self)
    }

    public func tabs<Output: UITabBarController>(
        of type: Output.Type
    ) -> ScreenChildRoute<Root, Output> {
        nest(action: ScreenTabsAction<Then, Output>())
    }

    public func tabs<Route: ScreenThenable>(
        route: Route
    ) -> Self where Route.Root: UITabBarController {
        nest(
            action: ScreenTabsAction<Then, Route.Root>(),
            nested: route
        )
    }

    public func tabs<Output: UITabBarController>(
        of type: Output.Type = Output.self,
        route: (_ route: ScreenRoute<Output>) -> ScreenRoute<Output>
    ) -> Self {
        tabs(route: route(.initial))
    }

    public func tabs<Output: UITabBarController, Next: ScreenContainer>(
        of type: Output.Type = Output.self,
        route: (_ route: ScreenRoute<Output>) -> ScreenChildRoute<Output, Next>
    ) -> Self {
        tabs(route: route(.initial))
    }
}
#endif
