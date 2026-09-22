import Foundation

public struct ScreenTryAction<Action: ScreenAction>: ScreenAction {

    public typealias Container = Action.Container
    public typealias Output = Void

    public typealias Resolution = ScreenTryResolution<
        Action.Container,
        Action.Output
    >

    public let action: Action
    public let resolution: Resolution

    public init(action: Action, resolution: Resolution) {
        self.action = action
        self.resolution = resolution
    }

    private func performResolutionActions(
        _ actions: [AnyScreenAction<Container, Void>],
        from index: Int = .zero,
        container: Container,
        navigator: ScreenNavigator,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        guard index < actions.count else {
            return completion(.success)
        }

        actions[index].perform(container: container, navigator: navigator) { result in
            switch result {
            case .success:
                performResolutionActions(
                    actions,
                    from: index + 1,
                    container: container,
                    navigator: navigator,
                    completion: completion
                )

            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    private func performEnsureActions(
        container: Container,
        navigator: ScreenNavigator,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        performResolutionActions(
            resolution.ensureActions,
            container: container,
            navigator: navigator,
            completion: completion
        )
    }

    private func performResultActions(
        ensureResult: Result<Void, Error>,
        actionResult: Result<Action.Output, Error>,
        container: Container,
        navigator: ScreenNavigator,
        completion: @escaping Completion
    ) {
        let actions: [AnyScreenAction<Container, Void>]

        switch (ensureResult, actionResult) {
        case (.failure, _):
            return completion(ensureResult)

        case (.success, let .failure(error)) where resolution.fallbackActions.isEmpty:
            return completion(.failure(error))

        case (.success, let .failure(error)):
            navigator.logInfo("Catching error: \(error)")

            actions = resolution
                .fallbackActions
                .compactMap { $0(error) }

        case (.success, let .success(value)):
            actions = resolution
                .doneActions
                .map { $0(value) }
        }

        performResolutionActions(
            actions,
            container: container,
            navigator: navigator,
            completion: completion
        )
    }

    private func performResolution(
        actionResult: Result<Action.Output, Error>,
        container: Container,
        navigator: ScreenNavigator,
        completion: @escaping Completion
    ) {
        performEnsureActions(container: container, navigator: navigator) { ensureResult in
            performResultActions(
                ensureResult: ensureResult,
                actionResult: actionResult,
                container: container,
                navigator: navigator,
                completion: completion
            )
        }
    }

    public func perform(
        container: Container,
        navigator: ScreenNavigator,
        completion: @escaping Completion
    ) {
        action.perform(container: container, navigator: navigator) { result in
            performResolution(
                actionResult: result,
                container: container,
                navigator: navigator,
                completion: completion
            )
        }
    }
}

extension ScreenThenable {

    public func `try`<Action: ScreenAction>(
        action: Action,
        resolution: ScreenTryResolution<Current, Action.Output>
    ) -> Self where Action.Container == Current {
        then(
            ScreenTryAction(
                action: action,
                resolution: resolution
            )
        )
    }

    public func `try`<Action: ScreenAction>(
        action: Action,
        resolution: (
            _ resolution: ScreenTryResolution<Current, Action.Output>
        ) -> ScreenTryResolution<Current, Action.Output>
    ) -> Self where Action.Container == Current {
        `try`(
            action: action,
            resolution: resolution(.initial)
        )
    }

    public func `try`<Action: ScreenAction, Route: ScreenThenable>(
        action: Action,
        done: @escaping (_ value: Action.Output) -> Route
    ) -> Self where Action.Container == Current, Route.Root == Current {
        `try`(action: action) { resolution in
            resolution.done(with: done)
        }
    }

    public func `try`<Action: ScreenAction>(
        action: Action,
        done: @escaping (
            _ value: Action.Output,
            _ route: ScreenRootRoute<Current>
        ) -> ScreenRouteConvertible
    ) -> Self where Action.Container == Current {
        `try`(action: action) { resolution in
            resolution.done(with: done)
        }
    }

    public func ensure<Route: ScreenThenable>(
        with route: Route
    ) -> ScreenRootRoute<Root> where Route.Root == Root {
        ScreenRootRoute(
            action: ScreenTryAction(
                action: ScreenNavigateAction(actions: actions),
                resolution: ScreenTryResolution
                    .initial
                    .ensure(with: route)
            )
        )
    }

    public func ensure(
        with route: (_ route: ScreenRootRoute<Root>) -> ScreenRouteConvertible
    ) -> ScreenRootRoute<Root> {
        ensure(with: route(.initial).route())
    }

    public func fallback<Route: ScreenThenable>(
        to route: @escaping (_ error: Error) -> Route
    ) -> ScreenRootRoute<Root> where Route.Root == Root {
        ScreenRootRoute(
            action: ScreenTryAction(
                action: ScreenNavigateAction(actions: actions),
                resolution: ScreenTryResolution
                    .initial
                    .fallback(to: route)
            )
        )
    }

    public func fallback(
        to route: @escaping (
            _ error: Error,
            _ route: ScreenRootRoute<Root>
        ) -> ScreenRouteConvertible
    ) -> ScreenRootRoute<Root> {
        fallback { route($0, .initial).route() }
    }

    public func fallback<Route: ScreenThenable>(
        to route: Route
    ) -> ScreenRootRoute<Root> where Route.Root == Root {
        fallback { _ in route }
    }

    public func cauterize() -> ScreenRootRoute<Root> {
        ScreenRootRoute(
            action: ScreenTryAction(
                action: ScreenNavigateAction(actions: actions),
                resolution: ScreenTryResolution
                    .initial
                    .cauterize()
            )
        )
    }
}
