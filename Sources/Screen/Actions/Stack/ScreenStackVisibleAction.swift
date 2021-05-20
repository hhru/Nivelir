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
            return completion(.invalidContainer(stackVisible, type: Output.self, for: self))
        }

        completion(.success(output))
    }
}

extension ScreenThenable where Then: UINavigationController {

    public var stackVisible: ScreenChildRoute<Root, UIViewController> {
        stackVisible(of: UIViewController.self)
    }

    public func stackVisible<Output: UIViewController>(
        of type: Output.Type
    ) -> ScreenChildRoute<Root, Output> {
        nest(action: ScreenStackVisibleAction<Then, Output>())
    }

    public func stackVisible<Route: ScreenThenable>(
        route: Route
    ) -> Self where Route.Root: UIViewController {
        nest(
            action: ScreenStackVisibleAction<Then, Route.Root>(),
            nested: route
        )
    }

    public func stackVisible<Output: UIViewController>(
        of type: Output.Type = Output.self,
        route: (_ route: ScreenRoute<Output>) -> ScreenRoute<Output>
    ) -> Self {
        stackVisible(route: route(.initial))
    }

    public func stackVisible<Output: UIViewController, Next: ScreenContainer>(
        of type: Output.Type = Output.self,
        route: (_ route: ScreenRoute<Output>) -> ScreenChildRoute<Output, Next>
    ) -> Self {
        stackVisible(route: route(.initial))
    }
}
#endif
