import UIKit

public struct ScreenStackTopAction<
    Container: UINavigationController,
    Output: UIViewController
>: ScreenAction {

    public init() { }

    public func perform(
        container: Container,
        navigation: ScreenNavigation,
        completion: @escaping Completion
    ) {
        guard let stackTop = container.stackTop else {
            return completion(.failure(ScreenContainerNotFoundError<UIViewController>(for: self)))
        }

        guard let output = stackTop as? Output else {
            return completion(.failure(ScreenInvalidContainerError<Output>(for: self)))
        }

        completion(.success(output))
    }
}

extension ScreenRoute where Container: UINavigationController {

    public func stackTop<Output: UIViewController>(
        of type: Output.Type,
        route: ScreenRoute<Output>
    ) -> Self {
        join(
            action: ScreenStackTopAction<Container, Output>(),
            route: route
        )
    }

    public func stackTop<Output: UIViewController>(
        of type: Output.Type,
        route: (_ route: ScreenRoute<Output>) -> ScreenRoute<Output>
    ) -> Self {
        stackTop(
            of: type,
            route: route(.initial)
        )
    }

    public func stackTop(route: ScreenModalRoute) -> Self {
        stackTop(
            of: UIViewController.self,
            route: route
        )
    }

    public func stackTop(route: (_ route: ScreenModalRoute) -> ScreenModalRoute) -> Self {
        stackTop(
            of: UIViewController.self,
            route: route
        )
    }
}
