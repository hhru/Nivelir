import Foundation

public struct ScreenNavigateToAction<Container: ScreenContainer>: ScreenAction {

    public typealias Output = Void

    public let route: ScreenRoute<Container>

    public init(route: ScreenRoute<Container>) {
        self.route = route
    }

    private func performRouteAction(
        at index: Int,
        container: Container,
        navigation: ScreenNavigation,
        completion: @escaping Completion
    ) {
        route.actions[index].performIfPossible(container: container, navigation: navigation) { result in
            switch result {
            case .success:
                let nextIndex = index + 1

                guard nextIndex < self.route.actions.count else {
                    return completion(.success)
                }

                self.performRouteAction(
                    at: nextIndex,
                    container: container,
                    navigation: navigation,
                    completion: completion
                )

            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    public func perform(
        container: Container,
        navigation: ScreenNavigation,
        completion: @escaping Completion
    ) {
        guard !route.isEmpty else {
            return completion(.success)
        }

        performRouteAction(
            at: .zero,
            container: container,
            navigation: navigation,
            completion: completion
        )
    }
}

extension ScreenNavigator {

    public func navigate(
        to route: ScreenWindowRoute,
        completion: Completion? = nil
    ) {
        perform(
            action: ScreenNavigateToAction(route: route),
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
}
