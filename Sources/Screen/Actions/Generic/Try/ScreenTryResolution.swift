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

    public func ensure(with action: AnyScreenAction<Container, Void>) -> Self {
        Self(
            ensureActions: ensureActions.appending(action),
            doneActions: doneActions,
            catchActions: catchActions
        )
    }

    public func ensure<Route: ScreenThenable>(with route: Route) -> Self where Route.Root == Container {
        ensure(with: ScreenNavigateAction(route: route).eraseToAnyVoidAction())
    }

    public func ensure(with route: (_ route: ScreenRoute<Container>) -> ScreenRoute<Container>) -> Self {
        ensure(with: route(.initial))
    }

    public func ensure<Next: ScreenContainer>(
        with route: (_ route: ScreenRoute<Container>) -> ScreenChildRoute<Container, Next>
    ) -> Self {
        ensure(with: route(.initial))
    }

    public func done(with action: @escaping DoneAction) -> Self {
        Self(
            ensureActions: ensureActions,
            doneActions: doneActions.appending(action),
            catchActions: catchActions
        )
    }

    public func done<Route: ScreenThenable>(
        with route: @escaping (_ value: Output) -> Route
    ) -> Self where Route.Root == Container {
        done { ScreenNavigateAction(route: route($0)).eraseToAnyVoidAction() }
    }

    public func done(
        with route: @escaping (
            _ value: Output,
            _ route: ScreenRoute<Container>
        ) -> ScreenRoute<Container>
    ) -> Self {
        done { route($0, .initial) }
    }

    public func done<Next: ScreenContainer>(
        with route: @escaping (
            _ value: Output,
            _ route: ScreenRoute<Container>
        ) -> ScreenChildRoute<Container, Next>
    ) -> Self {
        done { route($0, .initial) }
    }

    public func `catch`(with action: @escaping CatchAction) -> Self {
        Self(
            ensureActions: ensureActions,
            doneActions: doneActions,
            catchActions: catchActions.appending(action)
        )
    }

    public func `catch`<Failure: Error, Route: ScreenThenable>(
        _ errorType: Failure.Type,
        with route: @escaping (_ error: Failure) -> Route
    ) -> Self where Route.Root == Container {
        `catch` { error in
            if let error = error as? Failure {
                return ScreenNavigateAction(route: route(error)).eraseToAnyVoidAction()
            } else {
                return nil
            }
        }
    }

    public func `catch`<Failure: Error>(
        _ errorType: Failure.Type,
        with route: @escaping (
            _ error: Failure,
            _ route: ScreenRoute<Container>
        ) -> ScreenRoute<Container>
    ) -> Self {
        `catch`(errorType) { route($0, .initial) }
    }

    public func `catch`<Failure: Error, Next: ScreenContainer>(
        _ errorType: Failure.Type,
        with route: @escaping (
            _ error: Failure,
            _ route: ScreenRoute<Container>
        ) -> ScreenChildRoute<Container, Next>
    ) -> Self {
        `catch`(errorType) { route($0, .initial) }
    }

    public func `catch`<Route: ScreenThenable>(
        with route: @escaping (_ error: Error) -> Route
    ) -> Self where Route.Root == Container {
        `catch`(Error.self, with: route)
    }

    public func `catch`(
        with route: @escaping (
            _ error: Error,
            _ route: ScreenRoute<Container>
        ) -> ScreenRoute<Container>
    ) -> Self {
        `catch`(Error.self, with: route)
    }

    public func `catch`<Next: ScreenContainer>(
        with route: @escaping (
            _ error: Error,
            _ route: ScreenRoute<Container>
        ) -> ScreenChildRoute<Container, Next>
    ) -> Self {
        `catch`(Error.self, with: route)
    }
}
