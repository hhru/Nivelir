#if canImport(UIKit)
import UIKit

public struct ScreenPresentingAction<
    Container: UIViewController,
    Output: UIViewController
>: ScreenAction {

    public init() { }

    public func perform(
        container: Container,
        navigation: ScreenNavigation,
        completion: @escaping Completion
    ) {
        guard let presenting = container.presenting else {
            return completion(.failure(ScreenContainerNotFoundError<UIViewController>(for: self)))
        }

        guard let output = presenting as? Output else {
            return completion(.failure(ScreenInvalidContainerError<Output>(for: self)))
        }

        completion(.success(output))
    }
}

extension ScreenRoute where Container: UIViewController {

    public func presenting<Output: UIViewController>(
        of type: Output.Type,
        route: ScreenRoute<Output>
    ) -> Self {
        join(
            action: ScreenPresentingAction<Container, Output>(),
            route: route
        )
    }

    public func presenting<Output: UIViewController>(
        of type: Output.Type,
        route: (_ route: ScreenRoute<Output>) -> ScreenRoute<Output>
    ) -> Self {
        presenting(
            of: type,
            route: route(.initial)
        )
    }

    public func presenting(route: ScreenModalRoute) -> Self {
        presenting(
            of: UIViewController.self,
            route: route
        )
    }

    public func presenting(
        route: (_ route: ScreenModalRoute) -> ScreenModalRoute
    ) -> Self {
        presenting(
            of: UIViewController.self,
            route: route
        )
    }
}
#endif
