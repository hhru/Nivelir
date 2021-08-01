#if canImport(UIKit)
import UIKit

public struct ScreenStackRootAction<
    Container: UINavigationController,
    Output: UIViewController
>: ScreenAction {

    public init() { }

    public func perform(
        container: Container,
        navigator: ScreenNavigator,
        completion: @escaping Completion
    ) {
        guard let stackRoot = container.stackRoot else {
            return completion(.containerNotFound(type: UIViewController.self, for: self))
        }

        guard let output = stackRoot as? Output else {
            return completion(.containerTypeMismatch(stackRoot, type: Output.self, for: self))
        }

        completion(.success(output))
    }
}

extension ScreenRoute where Current: UINavigationController {

    public var stackRoot: ScreenRoute<Root, UIViewController> {
        stackRoot(of: UIViewController.self)
    }

    public func stackRoot<Output: UIViewController>(
        of type: Output.Type
    ) -> ScreenRoute<Root, Output> {
        fold(action: ScreenStackRootAction<Current, Output>())
    }

    public func stackRoot<Output: UIViewController, Next: ScreenContainer>(
        of type: Output.Type = Output.self,
        route: ScreenRoute<Output, Next>
    ) -> Self {
        fold(
            action: ScreenStackRootAction<Current, Output>(),
            nested: route
        )
    }

    public func stackRoot<Output: UIViewController>(
        of type: Output.Type = Output.self,
        route: (_ route: ScreenRootRoute<Output>) -> ScreenRouteConvertible
    ) -> Self {
        stackRoot(
            of: type,
            route: route(.initial).route()
        )
    }
}
#endif
