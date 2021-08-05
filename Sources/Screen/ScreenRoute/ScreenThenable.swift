import Foundation

/// A protocol representing the route to which actions can be added.
public protocol ScreenThenable {

    /// A type of root container that will be used to perform actions.
    ///
    /// - SeeAlso: `ScreenContainer`
    associatedtype Root: ScreenContainer

    /// A type of the current container, which is the container for the actions to be added.
    ///
    /// - SeeAlso: `ScreenContainer`
    associatedtype Current: ScreenContainer

    /// Route actions that can be performed in the root container.
    var actions: [AnyScreenAction<Root, Void>] { get }

    /// Adds actions.
    ///
    /// - Parameter actions: Actions to be added to the current actions.
    /// - Returns: An instance containing the new actions.
    func then(_ actions: [AnyScreenAction<Current, Void>]) -> Self

    /// Adds an action.
    ///
    /// - Parameter action: Action to be added to the current actions
    /// - Returns: An instance containing the new action.
    func then<Action: ScreenAction>(
        _ action: Action
    ) -> Self where Action.Container == Current

    /// Adds actions of another route.
    ///
    /// - Parameter other: The route whose actions will be added to the current actions.
    /// - Returns: An instance containing the new actions.
    func then<Route: ScreenThenable>(
        _ other: Route
    ) -> Self where Route.Root == Current
}
