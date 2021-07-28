import Foundation

public struct ScreenSubroute<
    Root: ScreenContainer,
    Then: ScreenContainer
>: ScreenThenable {

    public typealias Resolver = (
        _ route: ScreenRoute<Then>
    ) -> [AnyScreenAction<Root, Void>]

    private let resolver: Resolver
    private let route: ScreenRoute<Then>

    public var actions: [AnyScreenAction<Root, Void>] {
        resolver(route)
    }

    private init(
        resolver: @escaping Resolver,
        route: ScreenRoute<Then>
    ) {
        self.resolver = resolver
        self.route = route
    }

    public init(resolver: @escaping Resolver) {
        self.init(
            resolver: resolver,
            route: .initial
        )
    }

    private func changing(to route: ScreenRoute<Then>) -> Self {
        Self(resolver: resolver, route: route)
    }

    public func then<Action: ScreenAction>(
        _ action: Action
    ) -> Self where Action.Container == Then {
        changing(to: route.then(action))
    }

    public func then<Route: ScreenThenable>(
        _ other: Route
    ) -> Self where Route.Root == Then {
        changing(to: route.then(other))
    }
}
