import Foundation

public struct ScreenRoute<Container: ScreenContainer> {

    public static var initial: Self {
        Self()
    }

    internal let actions: [AnyScreenAction]

    public var isEmpty: Bool {
        actions.isEmpty
    }

    internal init(actions: [AnyScreenAction] = []) {
        self.actions = actions
    }

    public init(route: (_ route: Self) -> Self) {
        self = route(.initial)
    }

    private func then(actions: [AnyScreenAction]) -> Self {
        let newActions = actions.reduce(into: self.actions) { actions, action in
            guard let lastAction = actions.last else {
                return actions.append(action)
            }

            let newActions = lastAction.combine(with: action)

            actions.removeLast()
            actions.append(contentsOf: newActions)
        }

        return Self(actions: newActions)
    }

    public func then<Action: ScreenAction>(action: Action) -> Self where Action.Container == Container {
        then(actions: [action])
    }

    public func then(route: Self) -> Self {
        route.actions.isEmpty
            ? self
            : then(actions: route.actions)
    }
}
