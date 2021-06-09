#if canImport(UIKit)
import UIKit

public struct ScreenPresentedAction<
    Container: UIViewController,
    Output: UIViewController
>: ScreenAction {

    public init() { }

    public func perform(
        container: Container,
        navigator: ScreenNavigator,
        completion: @escaping Completion
    ) {
        guard let presented = container.presented else {
            return completion(.containerNotFound(type: UIViewController.self, for: self))
        }

        guard let output = presented as? Output else {
            return completion(.containerTypeMismatch(presented, type: Output.self, for: self))
        }

        completion(.success(output))
    }
}

extension ScreenRoute where Current: UIViewController {

    public var presented: ScreenRoute<Root, UIViewController> {
        presented(of: UIViewController.self)
    }

    public func presented<Output: UIViewController>(
        of type: Output.Type
    ) -> ScreenRoute<Root, Output> {
        fold(action: ScreenPresentedAction<Current, Output>())
    }

    public func presented<Output: UIViewController, Next: ScreenContainer>(
        of type: Output.Type = Output.self,
        route: ScreenRoute<Output, Next>
    ) -> Self {
        fold(
            action: ScreenPresentedAction<Current, Output>(),
            nested: route
        )
    }

    public func presented<Output: UIViewController>(
        of type: Output.Type = Output.self,
        route: (_ route: ScreenRootRoute<Output>) -> ScreenRouteConvertible
    ) -> Self {
        presented(
            of: type,
            route: route(.initial).route()
        )
    }
}
#endif
