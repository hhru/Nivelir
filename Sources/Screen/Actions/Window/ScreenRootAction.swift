#if canImport(UIKit)
import UIKit

public struct ScreenRootAction<
    Container: UIWindow,
    Output: UIViewController
>: ScreenAction {

    public init() { }

    public func perform(
        container: Container,
        navigator: ScreenNavigator,
        completion: @escaping Completion
    ) {
        guard let root = container.root else {
            return completion(.containerNotFound(type: UIViewController.self, for: self))
        }

        guard let output = root as? Output else {
            return completion(.containerTypeMismatch(root, type: Output.self, for: self))
        }

        completion(.success(output))
    }
}

extension ScreenRoute where Current: UIWindow {

    public var root: ScreenRoute<Root, UIViewController> {
        root(of: UIViewController.self)
    }

    public func root<Output: UIViewController>(
        of type: Output.Type = Output.self
    ) -> ScreenRoute<Root, Output> {
        fold(action: ScreenRootAction<Current, Output>())
    }

    public func root<Output: UIViewController, Next: ScreenContainer>(
        of type: Output.Type = Output.self,
        route: ScreenRoute<Output, Next>
    ) -> Self {
        fold(
            action: ScreenRootAction<Current, Output>(),
            nested: route
        )
    }

    public func root<Output: UIViewController>(
        of type: Output.Type = Output.self,
        route: (_ route: ScreenRootRoute<Output>) -> ScreenRouteConvertible
    ) -> Self {
        root(
            of: type,
            route: route(.initial).route()
        )
    }
}
#endif
