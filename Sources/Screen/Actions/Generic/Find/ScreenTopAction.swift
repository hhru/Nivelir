import Foundation

public struct ScreenTopAction<
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
        navigator.logInfo("Searching for a top container of \(Output.self) type in \(type(of: container))")

        let top = navigator.topContainer(in: container) { container in
            self.predicate.checkContainer(container)
        }

        guard let output = top as? Output else {
            return completion(.containerNotFound(type: Output.self, for: self))
        }

        completion(.success(output))
    }
}

extension ScreenThenable {

    public func top<Output: ScreenContainer>(
        _ predicate: ScreenPredicate<Output>
    ) -> ScreenRoute<Root, Output> {
        fold(action: ScreenTopAction<Current, Output>(predicate: predicate))
    }

    public func top<Output, Route: ScreenThenable>(
        _ predicate: ScreenPredicate<Output>,
        route: Route
    ) -> Self where Route.Root == Output {
        fold(
            action: ScreenTopAction(predicate: predicate),
            nested: route
        )
    }

    public func top<Output: ScreenContainer>(
        _ predicate: ScreenPredicate<Output>,
        route: (_ route: ScreenRootRoute<Output>) -> ScreenRouteConvertible
    ) -> Self {
        top(predicate, route: route(.initial).route())
    }
}
