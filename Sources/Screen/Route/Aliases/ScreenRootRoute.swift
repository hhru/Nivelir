import Foundation

public typealias ScreenRootRoute<Container: ScreenContainer> = ScreenRoute<Container, Container>

extension ScreenRoute where Root == Current {

    public static var initial: Self {
        Self()
    }

    public init(actions: [AnyScreenAction<Current, Void>] = []) {
        self.init(
            resolver: { $0 },
            tail: actions
        )
    }

    internal init<Action: ScreenAction>(action: Action) where Action.Container == Current {
        self.init(actions: [action.eraseToAnyVoidAction()])
    }

    public init(route: (_ route: Self) -> Self) {
        self.init(actions: route(.initial).actions)
    }
}
