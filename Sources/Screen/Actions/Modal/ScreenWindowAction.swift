#if canImport(UIKit)
import UIKit

/// Retrieves the window container of the current container.
public struct ScreenWindowAction<
    Container: UIViewController,
    Output: UIWindow
>: ScreenAction {

    /// Creates an action.
    public init() { }

    public func perform(
        container: Container,
        navigator: ScreenNavigator,
        completion: @escaping Completion
    ) {
        guard let window = container.window else {
            return completion(.containerNotFound(type: UIWindow.self, for: self))
        }

        guard let output = window as? Output else {
            return completion(.containerTypeMismatch(window, type: Output.self, for: self))
        }

        completion(.success(output))
    }
}

extension ScreenThenable where Current: UIViewController {

    /// Retrieves the window container of the current container.
    ///
    /// Usage examples
    /// ==============
    ///
    /// - Dismisses the screen container represented by the root container of the window:
    ///
    /// ``` swift
    /// navigator.navigate(from: container) { route in
    ///     route
    ///         .window
    ///         .root
    ///         .dismiss()
    /// }
    /// ```
    ///
    /// - Returns: An instance containing the new action.
    public var window: ScreenRoute<Root, UIWindow> {
        window(of: UIWindow.self)
    }

    /// Retrieves the window container of the current container.
    ///
    /// Usage examples
    /// ==============
    ///
    /// - Shows the window container of the current container and makes it the key window:
    ///
    /// ``` swift
    /// navigator.navigate(from: container) { route in
    ///     route
    ///         .window(of: UIWindow.self)
    ///         .makeKeyAndVisible()
    /// }
    /// ```
    ///
    /// - Parameter type: The type to which the container will be cast.
    /// - Returns: An instance containing the new action.
    public func window<Output: UIWindow>(
        of type: Output.Type
    ) -> ScreenRoute<Root, Output> {
        fold(action: ScreenWindowAction<Current, Output>())
    }

    /// Performs a route on the window container of the current container.
    ///
    /// Usage examples
    /// ==============
    ///
    /// - Dismisses the screen container represented by the root container of the window:
    ///
    /// ``` swift
    /// let nestedRoute = ScreenWindowRoute()
    ///     .root
    ///     .dismiss()
    ///
    /// navigator.navigate(from: container) { route in
    ///     route.window(of: UIWindow.self, route: nestedRoute)
    /// }
    /// ```
    ///
    /// - Shows the window container of the current container and makes it the key window:
    ///
    /// ``` swift
    /// navigator.navigate(from: container) { route in
    ///     route
    ///         .window(of: UIWindow.self)
    ///         .makeKeyAndVisible()
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - type: The type to which the container will be cast.
    ///   - route: The route that will be performed in the retrieved screen container.
    /// - Returns: An instance containing the new action.
    public func window<Output: UIWindow, Route: ScreenThenable>(
        of type: Output.Type = Output.self,
        route: Route
    ) -> Self where Route.Root == Output {
        fold(
            action: ScreenWindowAction<Current, Output>(),
            nested: route
        )
    }

    /// Performs a route on the window container of the current container.
    ///
    /// Usage examples
    /// ==============
    ///
    /// - Dismisses the screen container represented by the root container of the window:
    ///
    /// ``` swift
    /// navigator.navigate(from: container) { route in
    ///     route.window { $0.root.dismiss() }
    /// }
    /// ```
    ///
    /// - Shows the window container of the current container and makes it the key window:
    ///
    /// ``` swift
    /// navigator.navigate(from: container) { route in
    ///     route.window(of: UIWindow.self) { $0.makeKeyAndVisible() }
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - type: The type to which the container will be cast.
    ///   - route: The closure that should return the modified route
    ///            that will be performed in the retrieved screen container.
    /// - Returns: An instance containing the new action.
    public func window<Output: UIWindow>(
        of type: Output.Type = Output.self,
        route: (_ route: ScreenRootRoute<Output>) -> ScreenRouteConvertible
    ) -> Self {
        window(
            of: type,
            route: route(.initial).route()
        )
    }
}
#endif
