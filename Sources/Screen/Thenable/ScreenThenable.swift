import Foundation

public protocol ScreenThenable {

    associatedtype Root: ScreenContainer
    associatedtype Current: ScreenContainer

    var actions: [AnyScreenAction<Root, Void>] { get }

    func then<Action: ScreenAction>(
        _ action: Action
    ) -> Self where Action.Container == Current

    func then<Route: ScreenThenable>(
        _ other: Route
    ) -> Self where Route.Root == Current
}
