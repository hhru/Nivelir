import Foundation

public struct ScreenFirstAction<
    Container: ScreenContainer,
    Output: ScreenContainer
>: ScreenAction {

    public let predicate: ScreenPredicate<Output>

    public init(predicate: ScreenPredicate<Output>) {
        self.predicate = predicate
    }

    public func perform(
        container: Container,
        navigator: ScreenNavigator,
        completion: @escaping Completion
    ) {
        navigator.logInfo("Searching for a first container of \(Output.self) type in \(type(of: container))")

        let first = navigator.firstContainer(in: container) { container in
            self.predicate.checkContainer(container)
        }

        guard let output = first as? Output else {
            return completion(.containerNotFound(type: Output.self, for: self))
        }

        completion(.success(output))
    }
}

extension ScreenRoute {

    public func first<Output: ScreenContainer>(
        _ predicate: ScreenPredicate<Output>
    ) -> ScreenRoute<Root, Output> {
        fold(action: ScreenFirstAction<Current, Output>(predicate: predicate))
    }

    public func first<Output: ScreenContainer, Next: ScreenContainer>(
        _ predicate: ScreenPredicate<Output>,
        route: ScreenRoute<Output, Next>
    ) -> Self {
        fold(
            action: ScreenFirstAction(predicate: predicate),
            nested: route
        )
    }

    public func first<Output: ScreenContainer>(
        _ predicate: ScreenPredicate<Output>,
        route: (_ route: ScreenRootRoute<Output>) -> ScreenRouteConvertible
    ) -> Self {
        first(predicate, route: route(.initial).route())
    }
}
