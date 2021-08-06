import Foundation

public struct ScreenLastAction<
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
        navigator.logInfo("Searching for a last container of \(Output.self) type in \(type(of: container))")

        let last = navigator.lastContainer(in: container) { container in
            self.predicate.checkContainer(container)
        }

        guard let output = last as? Output else {
            return completion(.containerNotFound(type: Output.self, for: self))
        }

        completion(.success(output))
    }
}

extension ScreenThenable {

    public func last<Output: ScreenContainer>(
        _ predicate: ScreenPredicate<Output>
    ) -> ScreenRoute<Root, Output> {
        fold(action: ScreenLastAction<Current, Output>(predicate: predicate))
    }

    public func last<Output, Route: ScreenThenable>(
        _ predicate: ScreenPredicate<Output>,
        route: Route
    ) -> Self where Route.Root == Output {
        fold(
            action: ScreenLastAction(predicate: predicate),
            nested: route
        )
    }

    public func last<Output: ScreenContainer>(
        _ predicate: ScreenPredicate<Output>,
        route: (_ route: ScreenRootRoute<Output>) -> ScreenRouteConvertible
    ) -> Self {
        last(predicate, route: route(.initial).route())
    }
}
