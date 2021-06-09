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

extension ScreenRoute where Current: UITabBarController {

    public var selectedTab: ScreenRoute<Root, UIViewController> {
        selectedTab(of: UIViewController.self)
    }

    public func selectedTab<Output: UIViewController>(
        of type: Output.Type
    ) -> ScreenRoute<Root, Output> {
        fold(action: ScreenSelectedTabAction<Current, Output>())
    }

    public func selectedTab<Output: UIViewController, Next: ScreenContainer>(
        of type: Output.Type = Output.self,
        route: ScreenRoute<Output, Next>
    ) -> Self {
        fold(
            action: ScreenSelectedTabAction<Current, Output>(),
            nested: route
        )
    }

    public func selectedTab<Output: UIViewController>(
        of type: Output.Type = Output.self,
        route: (_ route: ScreenRootRoute<Output>) -> ScreenRouteConvertible
    ) -> Self {
        selectedTab(
            of: type,
            route: route(.initial).route()
        )
    }
}
#endif
