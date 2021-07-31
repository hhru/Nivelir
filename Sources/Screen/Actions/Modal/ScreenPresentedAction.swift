#if canImport(UIKit)
import UIKit

/// Obtains the container of the specified type that is presented by this container,
/// or one of its ancestors in the container hierarchy.
public struct ScreenPresentedAction<
    Container: UIViewController,
    Output: UIViewController
>: ScreenAction {

    /// Creates action.
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

extension ScreenThenable where Then: UIViewController {

    /// Obtains the modal container that is presented by this container,
    /// or one of its ancestors in the container hierarchy.
    ///
    /// Usage examples
    /// ==============
    ///
    /// - Dismisses the screen container that is presented by the presented container:
    ///
    /// ``` swift
    /// navigator.navigate(from: container) { route in
    ///     route
    ///         .presented
    ///         .dismiss()
    /// }
    /// ```
    ///
    /// - SeeAlso: `ScreenSubroute`
    /// - Returns: A subroute containing the new navigation action.
    public var presented: ScreenSubroute<Root, UIViewController> {
        presented(of: UIViewController.self)
    }

    /// Obtains the container of the specified type that is presented by this container,
    /// or one of its ancestors in the container hierarchy.
    ///
    /// Usage examples
    /// ==============
    ///
    /// - Pops the top screen container from the stack that is presented by the container:
    ///
    /// ``` swift
    /// navigator.navigate(from: container) { route in
    ///     route
    ///         .presented(of: UINavigationController.self)
    ///         .pop()
    /// }
    /// ```
    ///
    /// - Parameter type: The type to which the container will be cast.
    /// - Returns: A subroute containing the new navigation action.
    ///
    /// - SeeAlso: `ScreenSubroute`
    public func presented<Output: UIViewController>(
        of type: Output.Type
    ) -> ScreenSubroute<Root, Output> {
        nest(action: ScreenPresentedAction<Then, Output>())
    }

    /// Performs a route on the modal container that is presented by this container,
    /// or one of its ancestors in the container hierarchy.
    ///
    /// Usage examples
    /// ==============
    ///
    /// - Pops the top screen container from the stack that is presented by the container:
    ///
    /// ``` swift
    /// let nestedRoute = ScreenStackRoute
    ///     .initial
    ///     .pop()
    ///
    /// navigator.navigate(from: container) { route in
    ///     route.presented(of: UINavigationController.self, route: nestedRoute)
    /// }
    /// ```
    ///
    /// - Dismisses the screen container that is presented by the presented container:
    ///
    /// ``` swift
    /// let nestedRoute = ScreenModalRoute
    ///     .initial
    ///     .dismiss()
    ///
    /// navigator.navigate(from: container) { route in
    ///     route.presented(route: nestedRoute)
    /// }
    /// ```
    ///
    /// - Parameter route: The route that will be performed in the presented screen container.
    /// - Returns: An instance containing the new navigation action.
    public func presented<Output: UIViewController, Route: ScreenThenable>(
        of type: Output.Type = Output.self,
        route: Route
    ) -> Self where Route.Root: UIViewController {
        nest(
            action: ScreenPresentedAction<Then, Route.Root>(),
            nested: route
        )
    }

    /// Performs a route on the modal container that is presented by this container,
    /// or one of its ancestors in the container hierarchy.
    ///
    /// Usage examples
    /// ==============
    ///
    /// - Pops the top screen container from the stack that is presented by the container:
    ///
    /// ``` swift
    /// navigator.navigate(from: container) { route in
    ///     route.presented(of: UINavigationController.self) { $0.pop() }
    /// }
    /// ```
    ///
    /// - Dismisses the container that is presented by the presented container
    ///
    /// ``` swift
    /// navigator.navigate(from: self) { route in
    ///     route.presented { $0.dismiss() }
    /// }
    /// ```
    ///
    /// - Parameter route: The route that will be performed in the presented screen container.
    /// - Returns: An instance containing the new navigation action.
    ///
    /// - SeeAlso: `ScreenRoute`
    public func presented<Output: UIViewController>(
        of type: Output.Type = Output.self,
        route: (_ route: ScreenRoute<Output>) -> ScreenRoute<Output>
    ) -> Self {
        presented(of: type, route: route(.initial))
    }

    /// Performs a subroute on the modal container that is presented by this container,
    /// or one of its ancestors in the container hierarchy.
    ///
    /// Usage examples
    /// ==============
    ///
    /// - Pops the top screen container from the stack that is presented by the container:
    ///
    /// ``` swift
    /// navigator.navigate(from: container) { route in
    ///     route.presented(of: UINavigationController.self) { $0.pop() }
    /// }
    /// ```
    ///
    /// - Dismisses the container that is presented by the presented container
    ///
    /// ``` swift
    /// navigator.navigate(from: self) { route in
    ///     route.presented { $0.dismiss() }
    /// }
    /// ```
    ///
    /// - Parameter route: The route that will be performed in the presented screen container.
    /// - Returns: An instance containing the new navigation action.
    ///
    /// - SeeAlso: `ScreenSubroute`
    public func presented<Output: UIViewController, Next: ScreenContainer>(
        of type: Output.Type = Output.self,
        route: (_ route: ScreenRoute<Output>) -> ScreenSubroute<Output, Next>
    ) -> Self {
        presented(of: type, route: route(.initial))
    }
}
#endif
