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
            return completion(.failure(ScreenContainerNotFoundError<UITabBarController>(for: self)))
        }

        guard let output = tabs as? Output else {
            return completion(.failure(ScreenInvalidContainerError<Output>(for: self)))
        }

        completion(.success(output))
    }
}

extension ScreenRoute where Container: UIViewController {

    public func tabs<Output: UITabBarController>(
        of type: Output.Type,
        route: ScreenRoute<Output>
    ) -> Self {
        join(
            action: ScreenTabsAction<Container, Output>(),
            route: route
        )
    }

    public func tabs<Output: UITabBarController>(
        of type: Output.Type,
        route: (_ route: ScreenRoute<Output>) -> ScreenRoute<Output>
    ) -> Self {
        tabs(
            of: type,
            route: route(.initial)
        )
    }

    public func tabs(route: ScreenTabsRoute) -> Self {
        tabs(
            of: UITabBarController.self,
            route: route
        )
    }

    public func tabs(
        route: (_ route: ScreenTabsRoute) -> ScreenTabsRoute
    ) -> Self {
        tabs(
            of: UITabBarController.self,
            route: route
        )
    }
}
#endif
