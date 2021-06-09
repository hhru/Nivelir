#if canImport(UIKit)
import UIKit

public struct ScreenStackAction<
    Container: UIViewController,
    Output: UINavigationController
>: ScreenAction {

    public init() { }

    public func perform(
        container: Container,
        navigator: ScreenNavigator,
        completion: @escaping Completion
    ) {
        guard let stack = container.stack else {
            return completion(.containerNotFound(type: UINavigationController.self, for: self))
        }

        guard let output = stack as? Output else {
            return completion(.containerTypeMismatch(stack, type: Output.self, for: self))
        }

        completion(.success(output))
    }
}

extension ScreenRoute where Current: UIViewController {

    public var stack: ScreenRoute<Root, UINavigationController> {
        stack(of: UINavigationController.self)
    }

    public func stack<Output: UINavigationController>(
        of type: Output.Type
    ) -> ScreenRoute<Root, Output> {
        fold(action: ScreenStackAction<Current, Output>())
    }

    public func stack<Output: UINavigationController, Next: ScreenContainer>(
        of type: Output.Type = Output.self,
        route: ScreenRoute<Output, Next>
    ) -> Self {
        fold(
            action: ScreenStackAction<Current, Output>(),
            nested: route
        )
    }

    public func stack<Output: UINavigationController>(
        of type: Output.Type = Output.self,
        route: (_ route: ScreenRootRoute<Output>) -> ScreenRouteConvertible
    ) -> Self {
        stack(
            of: type,
            route: route(.initial).route()
        )
    }
}
#endif
