import Foundation

public struct ScreenNestAction<
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

extension ScreenThenable {

    public func nest<Action: ScreenAction>(
        action: Action
    ) -> ScreenChildRoute<Root, Action.Output> where Action.Container == Then {
        ScreenChildRoute { nested in
            nest(
                action: action,
                nested: nested
            ).actions
        }
    }

    public func nest<Action: ScreenAction, Nested: ScreenAction>(
        action: Action,
        nested: Nested
    ) -> Self where Action.Container == Then, Action.Output == Nested.Container {
        then(
            ScreenNestAction(
                action: action,
                nested: nested
            )
        )
    }

    public func nest<Action: ScreenAction, Nested: ScreenThenable>(
        action: Action,
        nested: Nested
    ) -> Self where Action.Container == Then, Action.Output == Nested.Root {
        nest(
            action: action,
            nested: ScreenNavigateAction(route: nested)
        )
    }

    public func nest<Action: ScreenAction>(
        action: Action,
        nested: (ScreenRoute<Action.Output>) -> ScreenRoute<Action.Output>
    ) -> Self where Action.Container == Then {
        nest(
            action: action,
            nested: nested(.initial)
        )
    }

    public func nest<Action: ScreenAction, Next: ScreenContainer>(
        action: Action,
        nested: (ScreenRoute<Action.Output>) -> ScreenChildRoute<Action.Output, Next>
    ) -> Self where Action.Container == Then {
        nest(
            action: action,
            nested: nested(.initial)
        )
    }
}
