import Foundation

public struct ScreenRoute<
    Root: ScreenContainer,
    Current: ScreenContainer
>: ScreenRouteConvertible {

    public typealias Resolver = (
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

    private func then(actions: [AnyScreenAction<Current, Void>]) -> Self {
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
        then(actions: [action.eraseToAnyVoidAction()])
    }

    public func then<Next: ScreenContainer>(
        _ other: ScreenRoute<Current, Next>
    ) -> Self {
        then(actions: other.actions)
    }

    public func route<Container: ScreenContainer>() -> ScreenRootRoute<Container> {
        ScreenRootRoute(actions: actions as? [AnyScreenAction<Container, Void>] ?? [])
    }
}
