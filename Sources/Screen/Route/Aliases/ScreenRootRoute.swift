import Foundation

/// Alias for a root route whose container type `Root` is equal to the `Current` type.
///
/// - SeeAlso: `ScreenRoute`
/// - SeeAlso: `ScreenContainer`
public typealias ScreenRootRoute<Container: ScreenContainer> = ScreenRoute<Container, Container>

extension ScreenRoute where Root == Current {

    /// Returns an empty initial instance of the route.
    public static var initial: Self {
        Self()
    }

    /// Creates a route with initial actions.
    ///
    /// - Parameter actions: Set of the initial actions of the route.
    public init(actions: [AnyScreenAction<Current, Void>] = []) {
        self.init(
            resolver: { $0 },
            tail: actions
        )
    }

    /// Creates a route with initial action.
    ///
    /// - Parameter action: Initial action of the route.
    public init<Action: ScreenAction>(action: Action) where Action.Container == Current {
        self.init(actions: [action.eraseToAnyVoidAction()])
    }

    /// Creates a route with initial actions added in the closure.
    ///
    /// - Parameter route: The closure that should return the modified route.
    public init(_ route: (_ route: ScreenRootRoute<Root>) throws -> ScreenRouteConvertible) rethrows {
        self.init(actions: try route(.initial).route().actions)
    }
}
