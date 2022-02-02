#if canImport(UIKit)
import UIKit

/// Retrieves the nearest ancestor in the container hierarchy that is a tabs container.
public struct ScreenTabsAction<
    Container: UIViewController,
    Output: UITabBarController
>: ScreenAction {

    /// Creates an action.
    public init() { }

    public func perform(
        container: Container,
        navigator: ScreenNavigator,
        completion: @escaping Completion
    ) {
        guard let tabs = container.tabs else {
            return completion(.containerNotFound(type: UITabBarController.self, for: self))
        }

        guard let output = tabs as? Output else {
            return completion(.containerTypeMismatch(tabs, type: Output.self, for: self))
        }

        completion(.success(output))
    }
}

extension ScreenThenable where Current: UIViewController {

    /// Retrieves the nearest ancestor in the container hierarchy that is a tabs container.
    ///
    /// Usage examples
    /// ==============
    ///
    /// - Selects tab from the tab container of the current container:
    ///
    /// ``` swift
    /// navigator.navigate(from: container) { route in
    ///     route
    ///         .tabs
    ///         .selectTab(with: .index(1))
    /// }
    /// ```
    ///
    /// - Returns: An instance containing the new action.
    public var tabs: ScreenRoute<Root, UITabBarController> {
        tabs(of: UITabBarController.self)
    }

    /// Retrieves the nearest ancestor in the container hierarchy that is a tabs container.
    ///
    /// Usage examples
    /// ==============
    ///
    /// - Selects tab from the tab container of the current container:
    ///
    /// ``` swift
    /// navigator.navigate(from: container) { route in
    ///     route
    ///         .tabs(of: MyTabBarController.self)
    ///         .selectTab(with: .index(1))
    /// }
    /// ```
    ///
    /// - Parameter type: The type to which the container will be cast.
    /// - Returns: An instance containing the new action.
    public func tabs<Output: UITabBarController>(
        of type: Output.Type
    ) -> ScreenRoute<Root, Output> {
        fold(action: ScreenTabsAction<Current, Output>())
    }

    /// Retrieves the nearest ancestor in the container hierarchy that is a tabs container.
    ///
    /// Usage examples
    /// ==============
    ///
    /// - Selects tab from the tab container of the current container:
    ///
    /// ``` swift
    /// let nestedRoute = ScreenTabsRoute().selectTab(with: .index(1))
    ///
    /// navigator.navigate(from: container) { route in
    ///     route.tabs(route: nestedRoute)
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - type: The type to which the container will be cast.
    ///   - route: The route that will be performed in the retrieved screen container.
    /// - Returns: An instance containing the new action.
    public func tabs<Output: UITabBarController, Route: ScreenThenable>(
        of type: Output.Type = Output.self,
        route: Route
    ) -> Self where Route.Root == Output {
        fold(
            action: ScreenTabsAction<Current, Output>(),
            nested: route
        )
    }

    /// Retrieves the nearest ancestor in the container hierarchy that is a tabs container.
    ///
    /// Usage examples
    /// ==============
    ///
    /// - Selects tab from the tab container of the current container:
    ///
    /// ``` swift
    /// navigator.navigate(from: container) { route in
    ///     route.tabs(route: nestedRoute) { $0.selectTab(with: .index(1)) }
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - type: The type to which the container will be cast.
    ///   - route: The closure that should return the modified route
    ///            that will be performed in the retrieved screen container.
    /// - Returns: An instance containing the new action.
    public func tabs<Output: UITabBarController>(
        of type: Output.Type = Output.self,
        route: (_ route: ScreenRootRoute<Output>) -> ScreenRouteConvertible
    ) -> Self {
        tabs(
            of: type,
            route: route(.initial).route()
        )
    }
}
#endif
