#if canImport(UIKit)
import UIKit

public struct ScreenStackVisibleAction<
    Container: UINavigationController,
    Output: UIViewController
>: ScreenAction {

    public init() { }

    public func perform(
        container: Container,
        navigation: ScreenNavigation,
        completion: @escaping Completion
    ) {
        guard let stackVisible = container.stackVisible else {
            return completion(.failure(ScreenContainerNotFoundError<UIViewController>(for: self)))
        }

        guard let output = stackVisible as? Output else {
            return completion(.failure(ScreenInvalidContainerError<Output>(for: self)))
        }

        completion(.success(output))
    }
}

extension ScreenRoute where Container: UINavigationController {

    public func stackVisible<Output: UIViewController>(
        of type: Output.Type,
        route: ScreenRoute<Output>
    ) -> Self {
        join(
            action: ScreenStackVisibleAction<Container, Output>(),
            route: route
        )
    }

    public func stackVisible<Output: UIViewController>(
        of type: Output.Type,
        route: (_ route: ScreenRoute<Output>) -> ScreenRoute<Output>
    ) -> Self {
        stackVisible(
            of: type,
            route: route(.initial)
        )
    }

    public func stackVisible(route: ScreenModalRoute) -> Self {
        stackVisible(
            of: UIViewController.self,
            route: route
        )
    }

    public func stackVisible(route: (_ route: ScreenModalRoute) -> ScreenModalRoute) -> Self {
        stackVisible(
            of: UIViewController.self,
            route: route
        )
    }
}
#endif
