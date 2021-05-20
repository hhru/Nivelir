import Foundation

public struct ScreenNavigateAction<Route: ScreenThenable>: ScreenAction {

    public typealias Container = Route.Root
    public typealias Output = Void

    public let route: Route

    public init(route: Route) {
        self.route = route
    }

    private func performRouteActions(
        _ actions: [AnyScreenAction<Container, Void>],
        from index: Int = .zero,
        container: Container,
        navigator: ScreenNavigator,
        completion: @escaping Completion
    ) {
        guard index < actions.count else {
            return completion(.success)
        }

        route.actions[index].perform(container: container, navigator: navigator) { result in
            switch result {
            case .success:
                self.performRouteActions(
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

    public func perform(
        container: Container,
        navigator: ScreenNavigator,
        completion: @escaping Completion
    ) {
        performRouteActions(
            route.actions,
            from: .zero,
            container: container,
            navigator: navigator,
            completion: completion
        )
    }
}

#if canImport(UIKit)
extension ScreenNavigator {

    public func navigate<Route: ScreenThenable>(
        to route: Route,
        completion: Completion? = nil
    ) where Route.Root == UIWindow {
        perform(
            action: ScreenNavigateAction(route: route),
            completion: completion
        )
    }

    public func navigate(
        to route: (ScreenWindowRoute) -> ScreenWindowRoute,
        completion: Completion? = nil
    ) {
        navigate(
            to: route(.initial),
            completion: completion
        )
    }

    public func navigate<Next: ScreenContainer>(
        to route: (ScreenWindowRoute) -> ScreenChildRoute<UIWindow, Next>,
        completion: Completion? = nil
    ) {
        navigate(
            to: route(.initial),
            completion: completion
        )
    }
}
#endif
