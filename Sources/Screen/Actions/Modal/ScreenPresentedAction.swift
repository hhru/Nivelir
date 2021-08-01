#if canImport(UIKit)
import UIKit

/// Retrieves the screen container that is presented by the current container,
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

extension ScreenRoute where Current: UIViewController {

    /// Retrieves the modal container that is presented by the current container,
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
    /// - Returns: An instance containing the new action.
    public var presented: ScreenRoute<Root, UIViewController> {
        presented(of: UIViewController.self)
    }

    /// Retrieves the screen container that is presented by the current container,
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
    /// - Returns: An instance containing the new action.
    public func presented<Output: UIViewController>(
        of type: Output.Type
    ) -> ScreenRoute<Root, Output> {
        fold(action: ScreenPresentedAction<Current, Output>())
    }

    /// Performs a route on the screen container that is presented by the current container,
    /// or one of its ancestors in the container hierarchy.
    ///
    /// Usage examples
    /// ==============
    ///
    /// - Pops the top screen container from the stack that is presented by the container:
    ///
    /// ``` swift
    /// let nestedRoute = ScreenStackRoute.pop()
    ///
    /// navigator.navigate(from: container) { route in
    ///     route.presented(of: UINavigationController.self, route: nestedRoute)
    /// }
    /// ```
    ///
    /// - Dismisses the screen container that is presented by the presented container:
    ///
    /// ``` swift
    /// let nestedRoute = ScreenModalRoute.dismiss()
    ///
    /// navigator.navigate(from: container) { route in
    ///     route.presented(route: nestedRoute)
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - type: The type to which the container will be cast.
    ///   - route: The route that will be performed in the retrieved screen container.
    /// - Returns: An instance containing the new action.
    public func presented<Output: UIViewController, Next: ScreenContainer>(
        of type: Output.Type = Output.self,
        route: ScreenRoute<Output, Next>
    ) -> Self {
        fold(
            action: ScreenPresentedAction<Current, Output>(),
            nested: route
        )
    }

    /// Performs a route on the screen container that is presented by the current container,
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
    /// - Dismisses the container that is presented by the presented container:
    ///
    /// ``` swift
    /// navigator.navigate(from: self) { route in
    ///     route.presented { $0.dismiss() }
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - type: The type to which the container will be cast.
    ///   - route: The closure that should return the modified route
    ///            that will be performed in the retrieved screen container.
    /// - Returns: An instance containing the new action.
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
