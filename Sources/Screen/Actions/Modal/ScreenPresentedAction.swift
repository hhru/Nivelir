#if canImport(UIKit)
import UIKit

public struct ScreenPresentedAction<
    Container: UIViewController,
    Output: UIViewController
>: ScreenAction {

    public init() { }

    public func perform(
        container: Container,
        navigation: ScreenNavigation,
        completion: @escaping Completion
    ) {
        guard let presented = container.presented else {
            return completion(.failure(ScreenContainerNotFoundError<UIViewController>(for: self)))
        }

        guard let output = presented as? Output else {
            return completion(.failure(ScreenInvalidContainerError<Output>(for: self)))
        }

        completion(.success(output))
    }
}

extension ScreenRoute where Container: UIViewController {

    public func presented<Output: UIViewController>(
        of type: Output.Type,
        route: ScreenRoute<Output>
    ) -> Self {
        join(
            action: ScreenPresentedAction<Container, Output>(),
            route: route
        )
    }

    public func presented<Output: UIViewController>(
        of type: Output.Type,
        route: (_ route: ScreenRoute<Output>) -> ScreenRoute<Output>
    ) -> Self {
        presented(
            of: type,
            route: route(.initial)
        )
    }

    public func presented(route: ScreenModalRoute) -> Self {
        presented(
            of: UIViewController.self,
            route: route
        )
    }

    public func presented(
        route: (_ route: ScreenModalRoute) -> ScreenModalRoute
    ) -> Self {
        presented(
            of: UIViewController.self,
            route: route
        )
    }
}
#endif
