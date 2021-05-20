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
                self.performResolutionActions(
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

        case (.success, let .failure(error)) where resolution.catchActions.isEmpty:
            return completion(.failure(error))

        case (.success, let .failure(error)):
            navigator.logInfo("Catching error: \(error)")

            actions = resolution
                .catchActions
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
            self.performResultActions(
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
        navigator.logInfo("Trying to perform \(action)")

        action.perform(container: container, navigator: navigator) { result in
            self.performResolution(
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
        resolution: ScreenTryResolution<Then, Action.Output>
    ) -> Self where Action.Container == Then {
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
            _ resolution: ScreenTryResolution<Then, Action.Output>
        ) -> ScreenTryResolution<Then, Action.Output>
    ) -> Self where Action.Container == Then {
        `try`(
            action: action,
            resolution: resolution(.initial)
        )
    }

    public func `try`<Action: ScreenAction, Done: ScreenThenable>(
        action: Action,
        done: @escaping (_ value: Action.Output) -> Done
    ) -> Self where Action.Container == Then, Done.Root == Then {
        `try`(action: action) { resolution in
            resolution.done(with: done)
        }
    }

    public func `try`<Action: ScreenAction>(
        action: Action,
        done: @escaping (
            _ value: Action.Output,
            _ route: ScreenRoute<Then>
        ) -> ScreenRoute<Then>
    ) -> Self where Action.Container == Then {
        `try`(action: action) { resolution in
            resolution.done(with: done)
        }
    }

    public func `try`<Action: ScreenAction, Next: ScreenContainer>(
        action: Action,
        done: @escaping (
            _ value: Action.Output,
            _ route: ScreenRoute<Then>
        ) -> ScreenChildRoute<Then, Next>
    ) -> Self where Action.Container == Then {
        `try`(action: action) { resolution in
            resolution.done(with: done)
        }
    }

    public func `catch`<Failure: Error, Route: ScreenThenable>(
        _ errorType: Failure.Type,
        route: @escaping (_ error: Failure) -> Route
    ) -> ScreenRoute<Root> where Route.Root == Root {
        ScreenRoute(
            action: ScreenTryAction(
                action: ScreenNavigateAction(route: self),
                resolution: ScreenTryResolution.initial.catch(errorType, with: route)
            )
        )
    }

    public func `catch`<Failure: Error>(
        _ errorType: Failure.Type,
        route: @escaping (
            _ error: Failure,
            _ route: ScreenRoute<Root>
        ) -> ScreenRoute<Root>
    ) -> ScreenRoute<Root> {
        `catch`(errorType) { route($0, .initial) }
    }

    public func `catch`<Failure: Error, Next: ScreenContainer>(
        _ errorType: Failure.Type,
        route: @escaping (
            _ error: Failure,
            _ route: ScreenRoute<Root>
        ) -> ScreenChildRoute<Root, Next>
    ) -> ScreenRoute<Root> {
        `catch`(errorType) { route($0, .initial) }
    }

    public func `catch`<Route: ScreenThenable>(
        route: @escaping (_ error: Error) -> Route
    ) -> ScreenRoute<Root> where Route.Root == Root {
        `catch`(Error.self, route: route)
    }

    public func `catch`(
        route: @escaping (
            _ error: Error,
            _ route: ScreenRoute<Root>
        ) -> ScreenRoute<Root>
    ) -> ScreenRoute<Root> {
        `catch`(Error.self, route: route)
    }

    public func `catch`<Next: ScreenContainer>(
        route: @escaping (
            _ error: Error,
            _ route: ScreenRoute<Root>
        ) -> ScreenChildRoute<Root, Next>
    ) -> ScreenRoute<Root> {
        `catch`(Error.self, route: route)
    }

    public func ensure<Route: ScreenThenable>(
        route: Route
    ) -> ScreenRoute<Root> where Route.Root == Root {
        ScreenRoute(
            action: ScreenTryAction(
                action: ScreenNavigateAction(route: self),
                resolution: ScreenTryResolution.initial.ensure(with: route)
            )
        )
    }

    public func ensure(
        route: (_ route: ScreenRoute<Root>) -> ScreenRoute<Root>
    ) -> ScreenRoute<Root> {
        ensure(route: route(.initial))
    }

    public func ensure<Next: ScreenContainer>(
        route: (_ route: ScreenRoute<Root>) -> ScreenChildRoute<Root, Next>
    ) -> ScreenRoute<Root> {
        ensure(route: route(.initial))
    }
}
