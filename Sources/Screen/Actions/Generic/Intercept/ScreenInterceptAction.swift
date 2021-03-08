import Foundation

public struct ScreenInterceptAction<Interceptor: ScreenInterceptor>: ScreenAction {

    public typealias Container = Interceptor.Container
    public typealias Output = Void

    public typealias Interception = ScreenInterception<
        Interceptor.Container,
        Interceptor.Output
    >

    public let interceptor: Interceptor
    public let interception: Interception

    public init(
        interceptor: Interceptor,
        interception: Interception
    ) {
        self.interceptor = interceptor
        self.interception = interception
    }

    private func performRoutes(
        _ routes: [ScreenRoute<Container>],
        container: Container,
        navigation: ScreenNavigation,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        let navigateToRoute = routes.reduce(ScreenRoute<Container>.initial) { result, route in
            result.then(route: route)
        }

        let navigateToAction = ScreenNavigateToAction(route: navigateToRoute)

        navigateToAction.perform(
            container: container,
            navigation: navigation,
            completion: completion
        )
    }

    private func performEnsureRoutes(
        container: Container,
        navigation: ScreenNavigation,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        performRoutes(
            interception.ensureRoutes,
            container: container,
            navigation: navigation,
            completion: completion
        )
    }

    private func performResultRoutes(
        ensureResult: Result<Void, Error>,
        interceptResult: Result<Interceptor.Output, Error>,
        container: Container,
        navigation: ScreenNavigation,
        completion: @escaping Completion
    ) {
        let routes: [ScreenRoute<Container>]

        switch (ensureResult, interceptResult) {
        case (.failure, _):
            return completion(ensureResult)

        case (.success, let .failure(error)) where interception.catchRoutes.isEmpty:
            return completion(.failure(error))

        case (.success, let .failure(error)):
            navigation.logger?.info("Catching interception with \(error)")

            routes = interception
                .catchRoutes
                .map { $0(.initial, error) }

        case (.success, let .success(value)):
            navigation.logger?.info("Completing interception with \(value)")

            routes = interception
                .doneRoutes
                .map { $0(.initial, value) }
        }

        performRoutes(
            routes,
            container: container,
            navigation: navigation,
            completion: completion
        )
    }

    private func performInterceptionRoutes(
        interceptResult: Result<Interceptor.Output, Error>,
        container: Container,
        navigation: ScreenNavigation,
        completion: @escaping Completion
    ) {
        performEnsureRoutes(container: container, navigation: navigation) { ensureResult in
            self.performResultRoutes(
                ensureResult: ensureResult,
                interceptResult: interceptResult,
                container: container,
                navigation: navigation,
                completion: completion
            )
        }
    }

    public func perform(
        container: Container,
        navigation: ScreenNavigation,
        completion: @escaping Completion
    ) {
        navigation.logger?.info("Intercepting \(container) with \(interceptor)")

        interceptor.perform(container: container, navigation: navigation) { interceptResult in
            self.performInterceptionRoutes(
                interceptResult: interceptResult,
                container: container,
                navigation: navigation,
                completion: completion
            )
        }
    }
}

extension ScreenRoute {

    public typealias Interception<Output> = ScreenInterception<Container, Output>

    public func intercept<Interceptor: ScreenInterceptor>(
        with interceptor: Interceptor,
        interception: Interception<Interceptor.Output>
    ) -> Self where Interceptor.Container == Container {
        then(
            action: ScreenInterceptAction(
                interceptor: interceptor,
                interception: interception
            )
        )
    }

    public func intercept<Interceptor: ScreenInterceptor>(
        with interceptor: Interceptor,
        interception: (_ resolution: Interception<Interceptor.Output>) -> Interception<Interceptor.Output>
    ) -> Self where Interceptor.Container == Container {
        intercept(
            with: interceptor,
            interception: interception(.initial)
        )
    }

    public func intercept<Interceptor: ScreenInterceptor>(
        with interceptor: Interceptor,
        done: @escaping Interception<Interceptor.Output>.DoneRoute
    ) -> Self where Interceptor.Container == Container {
        intercept(with: interceptor) { interception in
            interception.done(with: done)
        }
    }

    public func intercept<Interceptor: ScreenInterceptor>(
        with interceptor: Interceptor,
        done: ScreenRoute<Container>
    ) -> Self where Interceptor.Container == Container, Interceptor.Output == Void {
        intercept(with: interceptor) { route, _ in
            route.then(route: done)
        }
    }

    public func intercept<Interceptor: ScreenInterceptor>(
        with interceptor: Interceptor,
        done: (ScreenRoute<Container>) -> ScreenRoute<Container>
    ) -> Self where Interceptor.Container == Container, Interceptor.Output == Void {
        intercept(
            with: interceptor,
            done: done(.initial)
        )
    }
}
