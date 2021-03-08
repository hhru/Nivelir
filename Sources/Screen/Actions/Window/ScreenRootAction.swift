#if canImport(UIKit)
import UIKit

public struct ScreenRootAction<
    Container: UIWindow,
    Output: UIViewController
>: ScreenAction {

    public init() { }

    public func perform(
        container: Container,
        navigation: ScreenNavigation,
        completion: @escaping Completion
    ) {
        guard let root = container.root else {
            return completion(.failure(ScreenContainerNotFoundError<UIViewController>(for: self)))
        }

        guard let output = root as? Output else {
            return completion(.failure(ScreenInvalidContainerError<Output>(for: self)))
        }

        completion(.success(output))
    }
}

extension ScreenRoute where Container: UIWindow {

    public func root<Output: UIViewController>(
        of type: Output.Type,
        route: ScreenRoute<Output>
    ) -> Self {
        join(
            action: ScreenRootAction<Container, Output>(),
            route: route
        )
    }

    public func root<Output: UIViewController>(
        of type: Output.Type,
        route: (_ route: ScreenRoute<Output>) -> ScreenRoute<Output>
    ) -> Self {
        root(
            of: type,
            route: route(.initial)
        )
    }

    public func root(route: ScreenModalRoute) -> Self {
        root(
            of: UIViewController.self,
            route: route
        )
    }

    public func root(route: (_ route: ScreenModalRoute) -> ScreenModalRoute) -> Self {
        root(
            of: UIViewController.self,
            route: route
        )
    }
}
#endif
