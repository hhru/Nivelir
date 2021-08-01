import Foundation

public struct ScreenTryResolution<Container: ScreenContainer, Output> {

    public typealias DoneAction = (_ value: Output) -> AnyScreenAction<Container, Void>
    public typealias CatchAction = (_ error: Error) -> AnyScreenAction<Container, Void>?

    public static var initial: Self {
        Self()
    }

    public let ensureActions: [AnyScreenAction<Container, Void>]
    public let doneActions: [DoneAction]
    public let catchActions: [CatchAction]

    public init(
        ensureActions: [AnyScreenAction<Container, Void>] = [],
        doneActions: [DoneAction] = [],
        catchActions: [CatchAction] = []
    ) {
        self.ensureActions = ensureActions
        self.doneActions = doneActions
        self.catchActions = catchActions
    }

    public func ensure<Action: ScreenAction>(
        with action: Action
    ) -> Self where Action.Container == Container {
        Self(
            ensureActions: ensureActions.appending(action.eraseToAnyVoidAction()),
            doneActions: doneActions,
            catchActions: catchActions
        )
    }

    public func ensure<Next: ScreenContainer>(
        with route: ScreenRoute<Container, Next>
    ) -> Self {
        ensure(with: ScreenNavigateAction(actions: route.actions))
    }

    public func ensure(
        with route: (_ route: ScreenRootRoute<Container>) -> ScreenRouteConvertible
    ) -> Self {
        ensure(with: route(.initial).route())
    }

    public func done<Action: ScreenAction>(
        with action: @escaping (_ value: Output) -> Action
    ) -> Self where Action.Container == Container {
        let action = { action($0).eraseToAnyVoidAction() }

        return Self(
            ensureActions: ensureActions,
            doneActions: doneActions.appending(action),
            catchActions: catchActions
        )
    }

    public func done<Next: ScreenContainer>(
        with route: @escaping (_ value: Output) -> ScreenRoute<Container, Next>
    ) -> Self {
        done { value in
            ScreenNavigateAction(
                actions: route(value).actions
            ).eraseToAnyVoidAction()
        }
    }

    public func done(
        with route: @escaping (
            _ value: Output,
            _ route: ScreenRootRoute<Container>
        ) -> ScreenRouteConvertible
    ) -> Self {
        done { route($0, .initial).route() }
    }

    public func `catch`<Action: ScreenAction>(
        with action: @escaping (_ error: Error) -> Action?
    ) -> Self where Action.Container == Container {
        let action = { action($0)?.eraseToAnyVoidAction() }

        return Self(
            ensureActions: ensureActions,
            doneActions: doneActions,
            catchActions: catchActions.appending(action)
        )
    }

    public func `catch`<Next: ScreenContainer>(
        with route: @escaping (_ error: Error) -> ScreenRoute<Container, Next>
    ) -> Self {
        `catch` { error in
            ScreenNavigateAction(
                actions: route(error).actions
            ).eraseToAnyVoidAction()
        }
    }

    public func `catch`(
        with route: @escaping (
            _ error: Error,
            _ route: ScreenRootRoute<Container>
        ) -> ScreenRouteConvertible
    ) -> Self {
        `catch` { route($0, .initial).route() }
    }
}
