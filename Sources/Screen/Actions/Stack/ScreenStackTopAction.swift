#if canImport(UIKit)
import UIKit

public struct ScreenStackTopAction<
    Container: UINavigationController,
    Output: UIViewController
>: ScreenAction {

    public init() { }

    public func perform(
        container: Container,
        navigator: ScreenNavigator,
        completion: @escaping Completion
    ) {
        guard let stackTop = container.stackTop else {
            return completion(.containerNotFound(type: UIViewController.self, for: self))
        }

        guard let output = stackTop as? Output else {
            return completion(.containerTypeMismatch(stackTop, type: Output.self, for: self))
        }

        completion(.success(output))
    }
}

extension ScreenRoute where Current: UINavigationController {

    public var stackTop: ScreenRoute<Root, UIViewController> {
        stackTop(of: UIViewController.self)
    }

    public func stackTop<Output: UIViewController>(
        of type: Output.Type
    ) -> ScreenRoute<Root, Output> {
        fold(action: ScreenStackTopAction<Current, Output>())
    }

    public func stackTop<Output: UIViewController, Next: ScreenContainer>(
        of type: Output.Type = Output.self,
        route: ScreenRoute<Output, Next>
    ) -> Self {
        fold(
            action: ScreenStackTopAction<Current, Output>(),
            nested: route
        )
    }

    public func stackTop<Output: UIViewController>(
        of type: Output.Type = Output.self,
        route: (_ route: ScreenRootRoute<Output>) -> ScreenRouteConvertible
    ) -> Self {
        stackTop(
            of: type,
            route: route(.initial).route()
        )
    }
}
#endif
