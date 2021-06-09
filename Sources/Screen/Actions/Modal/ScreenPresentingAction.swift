#if canImport(UIKit)
import UIKit

public struct ScreenPresentingAction<
    Container: UIViewController,
    Output: UIViewController
>: ScreenAction {

    public init() { }

    public func perform(
        container: Container,
        navigator: ScreenNavigator,
        completion: @escaping Completion
    ) {
        guard let presenting = container.presenting else {
            return completion(.containerNotFound(type: UIViewController.self, for: self))
        }

        guard let output = presenting as? Output else {
            return completion(.containerTypeMismatch(presenting, type: Output.self, for: self))
        }

        completion(.success(output))
    }
}

extension ScreenRoute where Current: UIViewController {

    public var presenting: ScreenRoute<Root, UIViewController> {
        presenting(of: UIViewController.self)
    }

    public func presenting<Output: UIViewController>(
        of type: Output.Type
    ) -> ScreenRoute<Root, Output> {
        fold(action: ScreenPresentingAction<Current, Output>())
    }

    public func presenting<Output: UIViewController, Next: ScreenContainer>(
        of type: Output.Type = Output.self,
        route: ScreenRoute<Output, Next>
    ) -> Self {
        fold(
            action: ScreenPresentingAction<Current, Output>(),
            nested: route
        )
    }

    public func presenting<Output: UIViewController>(
        of type: Output.Type = Output.self,
        route: (_ route: ScreenRootRoute<Output>) -> ScreenRouteConvertible
    ) -> Self {
        presenting(
            of: type,
            route: route(.initial).route()
        )
    }
}
#endif
