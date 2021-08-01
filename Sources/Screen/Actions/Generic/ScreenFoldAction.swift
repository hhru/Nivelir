import Foundation

/// Performs a nested action in the container that will be retrieved by performing another action.
public struct ScreenFoldAction<
    Action: ScreenAction,
    Nested: ScreenAction
>: ScreenAction where Action.Output == Nested.Container {

    /// A type of container that the action uses for navigation.
    ///
    /// - SeeAlso: `ScreenContainer`
    public typealias Container = Action.Container

    /// The type of value returned by the action.
    public typealias Output = Nested.Output

    /// Action to retrieve the container.
    public let action: Action

    /// Nested action to be performed in the retrieved container.
    public let nested: Nested

    /// Creates action.
    ///
    /// - Parameters:
    ///   - action: Action to retrieve the container.
    ///   - nested: Nested action to be performed in the retrieved container.
    public init(action: Action, nested: Nested) {
        self.action = action
        self.nested = nested
    }

    public func perform(
        container: Container,
        navigator: ScreenNavigator,
        completion: @escaping Completion
    ) {
        action.perform(container: container, navigator: navigator) { result in
            switch result {
            case let .success(container):
                self.nested.perform(
                    container: container,
                    navigator: navigator,
                    completion: completion
                )

            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}

extension ScreenRoute {

    /// Performs action to retrieve the container that will be used to perform further actions of the route.
    ///
    /// - Parameter action: Action to retrieve the container.
    /// - Returns: An instance containing the new action.
    public func fold<Action: ScreenAction>(
        action: Action
    ) -> ScreenRoute<Root, Action.Output> where Action.Container == Current {
        ScreenRoute<Root, Action.Output> { nested in
            fold(
                action: action,
                nested: nested
            ).actions
        }
    }

    /// Performs a nested action in the container that will be retrieved by performing another action.
    ///
    /// - Parameters:
    ///   - action: Action to retrieve the container.
    ///   - nested: Nested action to be performed in the retrieved container.
    /// - Returns: An instance containing the new action.
    public func fold<Action: ScreenAction, Nested: ScreenAction>(
        action: Action,
        nested: Nested
    ) -> Self where Action.Container == Current, Action.Output == Nested.Container {
        then(
            ScreenFoldAction(
                action: action,
                nested: nested
            )
        )
    }

    /// Performs nested actions in the container that will be retrieved by performing another action.
    ///
    /// - Parameters:
    ///   - action: Action to retrieve the container.
    ///   - nested: Nested actions to be performed in the retrieved container.
    /// - Returns: An instance containing the new action.
    public func fold<Action: ScreenAction>(
        action: Action,
        nested: [AnyScreenAction<Action.Output, Void>]
    ) -> Self where Action.Container == Current, Action.Output: ScreenContainer {
        fold(
            action: action,
            nested: ScreenNavigateAction(actions: nested)
        )
    }

    /// Performs a nested rout in the container that will be retrieved by performing another action.
    ///
    /// - Parameters:
    ///   - action: Action to retrieve the container.
    ///   - nested: Nested route to be performed in the retrieved container.
    /// - Returns: An instance containing the new action.
    public func fold<Action: ScreenAction, Next: ScreenContainer>(
        action: Action,
        nested: ScreenRoute<Action.Output, Next>
    ) -> Self where Action.Container == Current {
        fold(
            action: action,
            nested: nested.actions
        )
    }

    /// Performs a nested rout in the container that will be retrieved by performing another action.
    ///
    /// - Parameters:
    ///   - action: Action to retrieve the container.
    ///   - nested: The closure that should return the modified route
    ///             that will be performed in the retrieved container.
    /// - Returns: An instance containing the new action.
    public func fold<Action: ScreenAction>(
        action: Action,
        nested: (_ route: ScreenRootRoute<Action.Output>) -> ScreenRouteConvertible
    ) -> Self where Action.Container == Current {
        fold(
            action: action,
            nested: nested(.initial).route()
        )
    }
}
