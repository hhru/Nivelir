#if canImport(UIKit)
import UIKit

public struct ScreenTabsAction<
    Container: UIViewController,
    Output: UITabBarController
>: ScreenAction {

    public init() { }

    public func perform(
        container: Container,
        navigator: ScreenNavigator,
        completion: @escaping Completion
    ) {
        guard let tabs = container.tabs else {
            return completion(.containerNotFound(type: UITabBarController.self, for: self))
        }

        guard let output = tabs as? Output else {
            return completion(.containerTypeMismatch(tabs, type: Output.self, for: self))
        }

        completion(.success(output))
    }
}

extension ScreenRoute where Current: UIViewController {

    public var tabs: ScreenRoute<Root, UITabBarController> {
        tabs(of: UITabBarController.self)
    }

    public func tabs<Output: UITabBarController>(
        of type: Output.Type
    ) -> ScreenRoute<Root, Output> {
        fold(action: ScreenTabsAction<Current, Output>())
    }

    public func tabs<Output: UITabBarController, Next: ScreenContainer>(
        of type: Output.Type = Output.self,
        route: ScreenRoute<Output, Next>
    ) -> Self {
        fold(
            action: ScreenTabsAction<Current, Output>(),
            nested: route
        )
    }

    public func tabs<Output: UITabBarController>(
        of type: Output.Type = Output.self,
        route: (_ route: ScreenRootRoute<Output>) -> ScreenRouteConvertible
    ) -> Self {
        tabs(
            of: type,
            route: route(.initial).route()
        )
    }
}
#endif
