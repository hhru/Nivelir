import Foundation

/// A type with a root route.
///
/// Can be used to erase the `ScreenRoute` type.
///
/// - SeeAlso: `ScreenRoute`
/// - SeeAlso: `ScreenRootRoute`
public protocol ScreenRouteConvertible {

    /// Returns the root route with the actions of the current instance.
    ///
    /// - Returns: An instance containing all the actions.
    func route<Container: ScreenContainer>() -> ScreenRootRoute<Container>
}

extension ScreenRoute: ScreenRouteConvertible {

    public func route<Container: ScreenContainer>() -> ScreenRootRoute<Container> {
        ScreenRootRoute(actions: actions as? [AnyScreenAction<Container, Void>] ?? [])
    }
}
