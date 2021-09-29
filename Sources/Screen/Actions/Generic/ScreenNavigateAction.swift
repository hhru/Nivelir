import Foundation

/// Performs a set of actions.
public struct ScreenNavigateAction<Container: ScreenContainer>: ScreenAction {

    /// The type of value returned by the action.
    public typealias Output = Void

    /// Actions to be performed.
    public let actions: [AnyScreenAction<Container, Void>]

    /// Creates an action.
    ///
    /// - Parameter actions: Actions to be performed.
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
import UIKit

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
        to route: (_ route: ScreenRootRoute<UIWindow>) -> ScreenRouteConvertible,
        completion: Completion? = nil
    ) {
        navigate(
            to: route(.initial).route(),
            completion: completion
        )
    }
}
#endif
