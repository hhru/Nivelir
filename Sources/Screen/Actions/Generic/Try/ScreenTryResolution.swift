import Foundation

@MainActor
public struct ScreenTryResolution<Container: ScreenContainer, Output> {

    public typealias DoneAction = (_ value: Output) -> AnyScreenAction<Container, Void>
    public typealias FallbackAction = (_ error: Error) -> AnyScreenAction<Container, Void>?

    public static var initial: Self {
        Self()
    }

    public let ensureActions: [AnyScreenAction<Container, Void>]
    public let doneActions: [DoneAction]
    public let fallbackActions: [FallbackAction]

    public init(
        ensureActions: [AnyScreenAction<Container, Void>] = [],
        doneActions: [DoneAction] = [],
        fallbackActions: [FallbackAction] = []
    ) {
        self.ensureActions = ensureActions
        self.doneActions = doneActions
        self.fallbackActions = fallbackActions
    }

    public func ensure<Action: ScreenAction>(
        with action: Action
    ) -> Self where Action.Container == Container {
        Self(
            ensureActions: ensureActions.appending(action.eraseToAnyVoidAction()),
            doneActions: doneActions,
            fallbackActions: fallbackActions
        )
    }

    public func ensure<Route: ScreenThenable>(
        with route: Route
    ) -> Self where Route.Root == Container {
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
            fallbackActions: fallbackActions
        )
    }

    public func done<Route: ScreenThenable>(
        with route: @escaping (_ value: Output) -> Route
    ) -> Self where Route.Root == Container {
        done { ScreenNavigateAction(actions: route($0).actions) }
    }

    public func done(
        with route: @escaping (
            _ value: Output,
            _ route: ScreenRootRoute<Container>
        ) -> ScreenRouteConvertible
    ) -> Self {
        done { route($0, .initial).route() }
    }

    public func fallback<Action: ScreenAction>(
        to action: @escaping (_ error: Error) -> Action?
    ) -> Self where Action.Container == Container {
        let action = { action($0)?.eraseToAnyVoidAction() }

        return Self(
            ensureActions: ensureActions,
            doneActions: doneActions,
            fallbackActions: fallbackActions.appending(action)
        )
    }

    public func fallback<Route: ScreenThenable>(
        to route: @escaping (_ error: Error) -> Route
    ) -> Self where Route.Root == Container {
        fallback { ScreenNavigateAction(actions: route($0).actions) }
    }

    public func fallback(
        to route: @escaping (
            _ error: Error,
            _ route: ScreenRootRoute<Container>
        ) -> ScreenRouteConvertible
    ) -> Self {
        fallback { route($0, .initial).route() }
    }

    public func fallback<Route: ScreenThenable>(
        with route: Route
    ) -> Self where Route.Root == Container {
        fallback { _ in route }
    }

    public func cauterize() -> Self {
        fallback { $1 }
    }
}
