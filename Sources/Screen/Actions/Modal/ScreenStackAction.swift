#if canImport(UIKit)
import UIKit

public struct ScreenStackAction<
    Container: UIViewController,
    Output: UINavigationController
>: ScreenAction {

    public init() { }

    public func perform(
        container: Container,
        navigation: ScreenNavigation,
        completion: @escaping Completion
    ) {
        guard let stack = container.stack else {
            return completion(.failure(ScreenContainerNotFoundError<UINavigationController>(for: self)))
        }

        guard let output = stack as? Output else {
            return completion(.failure(ScreenInvalidContainerError<Output>(for: self)))
        }

        completion(.success(output))
    }
}

extension ScreenRoute where Container: UIViewController {

    public func stack<Output: UINavigationController>(
        of type: Output.Type,
        route: ScreenRoute<Output>
    ) -> Self {
        join(
            action: ScreenStackAction<Container, Output>(),
            route: route
        )
    }

    public func stack<Output: UINavigationController>(
        of type: Output.Type,
        route: (_ route: ScreenRoute<Output>) -> ScreenRoute<Output>
    ) -> Self {
        stack(
            of: type,
            route: route(.initial)
        )
    }

    public func stack(route: ScreenStackRoute) -> Self {
        stack(
            of: UINavigationController.self,
            route: route
        )
    }

    public func stack(
        route: (_ route: ScreenStackRoute) -> ScreenStackRoute
    ) -> Self {
        stack(
            of: UINavigationController.self,
            route: route
        )
    }
}
#endif
