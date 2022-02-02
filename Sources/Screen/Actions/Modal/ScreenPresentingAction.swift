#if canImport(UIKit)
import UIKit

/// Retrieves the screen container that presented the current container.
public struct ScreenPresentingAction<
    Container: UIViewController,
    Output: UIViewController
>: ScreenAction {

    /// Creates an action.
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

extension ScreenThenable where Current: UIViewController {

    /// Retrieves the modal container that presented the current container.
    ///
    /// Usage examples
    /// ==============
    ///
    /// - Dismisses the current container:
    ///
    /// ``` swift
    /// navigator.navigate(from: container) { route in
    ///     route
    ///         .presenting
    ///         .dismiss()
    /// }
    /// ```
    ///
    /// - Returns: An instance containing the new action.
    public var presenting: ScreenRoute<Root, UIViewController> {
        presenting(of: UIViewController.self)
    }

    /// Retrieves the screen container that presented the current container.
    ///
    /// Usage examples
    /// ==============
    ///
    /// - Pops the top screen container from the stack that presented the current container:
    ///
    /// ``` swift
    /// navigator.navigate(from: container) { route in
    ///     route
    ///         .presenting(of: UINavigationController.self)
    ///         .pop()
    /// }
    /// ```
    ///
    /// - Parameter type: The type to which the container will be cast.
    /// - Returns: An instance containing the new action.
    public func presenting<Output: UIViewController>(
        of type: Output.Type
    ) -> ScreenRoute<Root, Output> {
        fold(action: ScreenPresentingAction<Current, Output>())
    }

    /// Performs a route on the screen container that presented the current container.
    ///
    /// Usage examples
    /// ==============
    ///
    /// - Pops the top screen container from the stack that presented the current container:
    ///
    /// ``` swift
    /// let nestedRoute = ScreenStackRoute().pop()
    ///
    /// navigator.navigate(from: container) { route in
    ///     route.presenting(of: UINavigationController.self, route: nestedRoute)
    /// }
    /// ```
    ///
    /// - Dismisses the current container:
    ///
    /// ``` swift
    /// let nestedRoute = ScreenModalRoute().dismiss()
    ///
    /// navigator.navigate(from: container) { route in
    ///     route.presenting(route: nestedRoute)
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - type: The type to which the container will be cast.
    ///   - route: The route that will be performed in the retrieved screen container.
    /// - Returns: An instance containing the new action.
    public func presenting<Output: UIViewController, Next: ScreenContainer>(
        of type: Output.Type = Output.self,
        route: ScreenRoute<Output, Next>
    ) -> Self {
        fold(
            action: ScreenPresentingAction<Current, Output>(),
            nested: route
        )
    }

    /// Performs a route on the screen container that presented the current container.
    ///
    /// Usage examples
    /// ==============
    ///
    /// - Pops the top screen container from the stack that presented the current container:
    ///
    /// ``` swift
    /// navigator.navigate(from: container) { route in
    ///     route.presenting(of: UINavigationController.self) { $0.pop() }
    /// }
    /// ```
    ///
    /// - Dismisses the current container:
    ///
    /// ``` swift
    /// navigator.navigate(from: container) { route in
    ///     route.presenting { $0.dismiss() }
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - type: The type to which the container will be cast.
    ///   - route: The closure that should return the modified route
    ///            that will be performed in the retrieved screen container.
    /// - Returns: An instance containing the new action.
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
