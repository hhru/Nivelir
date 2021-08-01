#if canImport(UIKit)
import UIKit

/// Obtains the nearest ancestor in the container hierarchy that is a stack container.
public struct ScreenStackAction<
    Container: UIViewController,
    Output: UINavigationController
>: ScreenAction {

    /// Creates action.
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

    /// Obtains the nearest ancestor in the container hierarchy that is a stack container.
    ///
    /// Usage examples
    /// ==============
    ///
    /// - Pops the top screen container from the stack of the current container:
    ///
    /// ``` swift
    /// navigator.navigate(from: container) { route in
    ///     route
    ///         .stack
    ///         .pop()
    /// }
    /// ```
    ///
    /// - Returns: An instance containing the new action.
    public var stack: ScreenRoute<Root, UINavigationController> {
        stack(of: UINavigationController.self)
    }

    /// Obtains the nearest ancestor in the container hierarchy that is a stack container.
    ///
    /// Usage examples
    /// ==============
    ///
    /// - Pops the top screen container from the stack of the current container:
    ///
    /// ``` swift
    /// navigator.navigate(from: container) { route in
    ///     route
    ///         .stack(of: MyNavigationController.self)
    ///         .pop()
    /// }
    /// ```
    ///
    /// - Parameter type: The type to which the container will be cast.
    /// - Returns: An instance containing the new action.
    public func stack<Output: UINavigationController>(
        of type: Output.Type
    ) -> ScreenRoute<Root, Output> {
        fold(action: ScreenStackAction<Current, Output>())
    }

    /// Performs a route on the nearest ancestor in the container hierarchy that is a stack container.
    ///
    /// Usage examples
    /// ==============
    ///
    /// - Pops the top screen container from the stack of the current container:
    ///
    /// ``` swift
    /// let nestedRoute = ScreenStackRoute.pop()
    ///
    /// navigator.navigate(from: container) { route in
    ///     route.stack(route: nestedRoute)
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - type: The type to which the container will be cast.
    ///   - route: The route that will be performed in the obtained screen container.
    /// - Returns: An instance containing the new action.
    public func stack<Output: UINavigationController, Next: ScreenContainer>(
        of type: Output.Type = Output.self,
        route: ScreenRoute<Output, Next>
    ) -> Self {
        fold(
            action: ScreenStackAction<Current, Output>(),
            nested: route
        )
    }

    /// Performs a route on the nearest ancestor in the container hierarchy that is a stack container.
    ///
    /// Usage examples
    /// ==============
    ///
    /// - Pops the top screen container from the stack of the current container:
    ///
    /// ``` swift
    /// navigator.navigate(from: container) { route in
    ///     route.stack { $0.pop() }
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - type: The type to which the container will be cast.
    ///   - route: The closure that should return the modified route
    ///            that will be performed in the obtained screen container.
    /// - Returns: An instance containing the new action.
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
