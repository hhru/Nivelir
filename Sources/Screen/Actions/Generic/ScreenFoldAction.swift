import Foundation

public struct ScreenFoldAction<
    Action: ScreenAction,
    Nested: ScreenAction
>: ScreenAction where Action.Output == Nested.Container {

    public typealias Container = Action.Container
    public typealias Output = Nested.Output

    public let action: Action
    public let nested: Nested

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

    public func fold<Action: ScreenAction>(
        action: Action,
        nested: [AnyScreenAction<Action.Output, Void>]
    ) -> Self where Action.Container == Current, Action.Output: ScreenContainer {
        fold(
            action: action,
            nested: ScreenNavigateAction(actions: nested)
        )
    }

    public func fold<Action: ScreenAction, Next: ScreenContainer>(
        action: Action,
        nested: ScreenRoute<Action.Output, Next>
    ) -> Self where Action.Container == Current {
        fold(
            action: action,
            nested: nested.actions
        )
    }

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
