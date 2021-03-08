import Foundation

public struct ScreenJoinAction<
    First: ScreenAction,
    Second: ScreenAction
>: ScreenAction where First.Output == Second.Container {

    public typealias Container = First.Container
    public typealias Output = Second.Output

    public let first: First
    public let second: Second

    public init(first: First, second: Second) {
        self.first = first
        self.second = second
    }

    public func perform(
        container: Container,
        navigation: ScreenNavigation,
        completion: @escaping Completion
    ) {
        first.perform(container: container, navigation: navigation) { result in
            switch result {
            case let .success(container):
                second.perform(
                    container: container,
                    navigation: navigation,
                    completion: completion
                )

            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}

extension ScreenRoute {

    public func join<First: ScreenAction, Second: ScreenAction>(
        first: First,
        second: Second
    ) -> Self where First.Container == Container, First.Output == Second.Container {
        then(
            action: ScreenJoinAction(
                first: first,
                second: second
            )
        )
    }

    public func join<Action: ScreenAction>(
        action: Action,
        route: ScreenRoute<Action.Output>
    ) -> Self where Action.Container == Container, Action.Output: ScreenContainer {
        join(
            first: action,
            second: ScreenNavigateToAction(route: route)
        )
    }

    public func join<Action: ScreenAction>(
        action: Action,
        route: (ScreenRoute<Action.Output>) -> ScreenRoute<Action.Output>
    ) -> Self where Action.Container == Container, Action.Output: ScreenContainer {
        join(
            action: action,
            route: route(.initial)
        )
    }
}
