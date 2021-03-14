import Foundation

public struct ScreenRoute<Container: ScreenContainer>: ScreenThenable {

    public typealias Root = Container
    public typealias Then = Container

    public static var initial: Self {
        Self()
    }

    public let actions: [AnyScreenAction<Container, Void>]

    public var isEmpty: Bool {
        actions.isEmpty
    }

    internal init(actions: [AnyScreenAction<Container, Void>] = []) {
        self.actions = actions
    }

    internal init<Action: ScreenAction>(action: Action) where Action.Container == Container {
        self.actions = [action.eraseToAnyVoidAction()]
    }

    public init(route: (_ route: Self) -> Self) {
        self = route(.initial)
    }

    private func then(actions: [AnyScreenAction<Container, Void>]) -> Self {
        let newActions = actions.reduce(into: self.actions) { actions, action in
            if let newAction = actions.last?.combine(with: action) {
                actions.removeLast()
                actions.append(newAction)
            } else {
                actions.append(action)
            }
        }

        return Self(actions: newActions)
    }

    public func then<Action: ScreenAction>(
        _ action: Action
    ) -> Self where Action.Container == Container {
        then(actions: [action.eraseToAnyVoidAction()])
    }

    public func then<Route: ScreenThenable>(
        _ other: Route
    ) -> Self where Route.Root == Container {
        then(actions: other.actions)
    }
}
