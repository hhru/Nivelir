import Foundation

/// A route that describes navigation as a set of actions.
///
/// `ScreenRoute` is built from a set of navigation actions
/// and contains the root and the current container type on which these actions will be performed.
/// The actions that can be added to route are constrained to the current container type.
public struct ScreenRoute<
    Root: ScreenContainer,
    Current: ScreenContainer
>: ScreenThenable {

    internal typealias Resolver = (
        _ actions: [AnyScreenAction<Current, Void>]
    ) -> [AnyScreenAction<Root, Void>]

    internal let resolver: Resolver
    internal let tail: [AnyScreenAction<Current, Void>]

    public var actions: [AnyScreenAction<Root, Void>] {
        resolver(tail)
    }

    internal init(
        resolver: @escaping Resolver,
        tail: [AnyScreenAction<Current, Void>] = []
    ) {
        self.resolver = resolver
        self.tail = tail
    }

    public func then(_ actions: [AnyScreenAction<Current, Void>]) -> Self {
        let newTail = actions.reduce(into: tail) { actions, action in
            if let newAction = actions.last?.combine(with: action) {
                actions.removeLast()
                actions.append(newAction)
            } else {
                actions.append(action)
            }
        }

        return Self(
            resolver: resolver,
            tail: newTail
        )
    }

    public func then<Action: ScreenAction>(
        _ action: Action
    ) -> Self where Action.Container == Current {
        then([action.eraseToAnyVoidAction()])
    }

    public func then<Route: ScreenThenable>(
        _ other: Route
    ) -> Self where Route.Root == Current {
        then(other.actions)
    }

    /// Returns the root route with the actions of the current instance.
    ///
    /// - Returns: An instance containing all the actions.
    public func resolve() -> ScreenRootRoute<Root> {
        ScreenRootRoute(actions: actions)
    }
}
