import Foundation

public struct ScreenNavigateAction<Container: ScreenContainer>: ScreenAction {

    public typealias Output = Void

    public let actions: [AnyScreenAction<Container, Void>]

    public init(actions: [AnyScreenAction<Container, Void>]) {
        self.actions = actions
    }

    private func performActions(
        _ actions: [AnyScreenAction<Container, Void>],
        from index: Int = .zero,
        container: Container,
        navigator: ScreenNavigator,
        completion: @escaping Completion
    ) {
        guard index < actions.count else {
            return completion(.success)
        }

        actions[index].perform(container: container, navigator: navigator) { result in
            switch result {
            case .success:
                self.performActions(
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
        performActions(
            actions,
            from: .zero,
            container: container,
            navigator: navigator,
            completion: completion
        )
    }
}

#if canImport(UIKit)
extension ScreenNavigator {

    public func navigate<New: ScreenContainer>(
        to route: ScreenRoute<UIWindow, New>,
        completion: Completion? = nil
    ) {
        perform(
            action: ScreenNavigateAction(actions: route.actions),
            completion: completion
        )
    }

    public func navigate(
        to route: (_ route: ScreenWindowRoute) -> ScreenRouteConvertible,
        completion: Completion? = nil
    ) {
        navigate(
            to: route(.initial).route(),
            completion: completion
        )
    }
}
#endif
