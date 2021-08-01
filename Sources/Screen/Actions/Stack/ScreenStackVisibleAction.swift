#if canImport(UIKit)
import UIKit

public struct ScreenStackVisibleAction<
    Container: UINavigationController,
    Output: UIViewController
>: ScreenAction {

    public init() { }

    public func perform(
        container: Container,
        navigator: ScreenNavigator,
        completion: @escaping Completion
    ) {
        guard let stackVisible = container.stackVisible else {
            return completion(.containerNotFound(type: UIViewController.self, for: self))
        }

        guard let output = stackVisible as? Output else {
            return completion(.containerTypeMismatch(stackVisible, type: Output.self, for: self))
        }

        completion(.success(output))
    }
}

extension ScreenRoute where Current: UINavigationController {

    public var stackVisible: ScreenRoute<Root, UIViewController> {
        stackVisible(of: UIViewController.self)
    }

    public func stackVisible<Output: UIViewController>(
        of type: Output.Type
    ) -> ScreenRoute<Root, Output> {
        fold(action: ScreenStackVisibleAction<Current, Output>())
    }

    public func stackVisible<Output: UIViewController, Next: ScreenContainer>(
        of type: Output.Type = Output.self,
        route: ScreenRoute<Output, Next>
    ) -> Self {
        fold(
            action: ScreenStackVisibleAction<Current, Output>(),
            nested: route
        )
    }

    public func stackVisible<Output: UIViewController>(
        of type: Output.Type = Output.self,
        route: (_ route: ScreenRootRoute<Output>) -> ScreenRouteConvertible
    ) -> Self {
        stackVisible(
            of: type,
            route: route(.initial).route()
        )
    }
}
#endif
