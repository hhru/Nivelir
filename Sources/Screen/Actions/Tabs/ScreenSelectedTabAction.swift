#if canImport(UIKit)
import UIKit

public struct ScreenSelectedTabAction<
    Container: UITabBarController,
    Output: UIViewController
>: ScreenAction {

    public init() { }

    public func perform(
        container: Container,
        navigation: ScreenNavigation,
        completion: @escaping Completion
    ) {
        guard let selectedTab = container.selectedTab else {
            return completion(.failure(ScreenContainerNotFoundError<UIViewController>(for: self)))
        }

        guard let output = selectedTab as? Output else {
            return completion(.failure(ScreenInvalidContainerError<Output>(for: self)))
        }

        completion(.success(output))
    }
}

extension ScreenRoute where Container: UITabBarController {

    public func selectedTab<Output: UIViewController>(
        of type: Output.Type,
        route: ScreenRoute<Output>
    ) -> Self {
        join(
            action: ScreenSelectedTabAction<Container, Output>(),
            route: route
        )
    }

    public func selectedTab<Output: UIViewController>(
        of type: Output.Type,
        route: (_ route: ScreenRoute<Output>) -> ScreenRoute<Output>
    ) -> Self {
        selectedTab(
            of: type,
            route: route(.initial)
        )
    }

    public func selectedTab(route: ScreenModalRoute) -> Self {
        selectedTab(
            of: UIViewController.self,
            route: route
        )
    }

    public func selectedTab(
        route: (_ route: ScreenModalRoute) -> ScreenModalRoute
    ) -> Self {
        selectedTab(
            of: UIViewController.self,
            route: route
        )
    }
}
#endif
