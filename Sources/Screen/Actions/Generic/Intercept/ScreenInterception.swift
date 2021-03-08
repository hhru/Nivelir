import Foundation

public struct ScreenInterception<Container: ScreenContainer, Output> {

    public typealias DoneRoute = (
        _ route: ScreenRoute<Container>,
        _ value: Output
    ) -> ScreenRoute<Container>

    public typealias CatchRoute = (
        _ route: ScreenRoute<Container>,
        _ error: Error
    ) -> ScreenRoute<Container>

    public static var initial: Self {
        Self()
    }

    public let ensureRoutes: [ScreenRoute<Container>]
    public let doneRoutes: [DoneRoute]
    public let catchRoutes: [CatchRoute]

    public init(
        ensureRoutes: [ScreenRoute<Container>] = [],
        doneRoutes: [DoneRoute] = [],
        catchRoutes: [CatchRoute] = []
    ) {
        self.ensureRoutes = ensureRoutes
        self.doneRoutes = doneRoutes
        self.catchRoutes = catchRoutes
    }

    public func ensure(with ensureRoute: ScreenRoute<Container>) -> Self {
        Self(
            ensureRoutes: ensureRoutes.appending(ensureRoute),
            doneRoutes: doneRoutes,
            catchRoutes: catchRoutes
        )
    }

    public func ensure(with ensureRoute: (ScreenRoute<Container>) -> ScreenRoute<Container>) -> Self {
        ensure(with: ensureRoute(.initial))
    }

    public func done(with doneRoute: @escaping DoneRoute) -> Self {
        Self(
            ensureRoutes: ensureRoutes,
            doneRoutes: doneRoutes.appending(doneRoute),
            catchRoutes: catchRoutes
        )
    }

    public func done(with doneRoute: ScreenRoute<Container>) -> Self {
        done { done, _ in
            done.then(route: doneRoute)
        }
    }

    public func done(with doneRoute: (ScreenRoute<Container>) -> ScreenRoute<Container>) -> Self {
        done(with: doneRoute(.initial))
    }

    public func `catch`(with catchRoute: @escaping CatchRoute) -> Self {
        Self(
            ensureRoutes: ensureRoutes,
            doneRoutes: doneRoutes,
            catchRoutes: catchRoutes.appending(catchRoute)
        )
    }

    public func `catch`(with catchRoute: ScreenRoute<Container>) -> Self {
        `catch` { route, _ in
            route.then(route: catchRoute)
        }
    }

    public func `catch`(with catchRoute: (ScreenRoute<Container>) -> ScreenRoute<Container>) -> Self {
        `catch`(with: catchRoute(.initial))
    }

    public func cauterize() -> Self {
        `catch` { route, _ in
            route
        }
    }
}
