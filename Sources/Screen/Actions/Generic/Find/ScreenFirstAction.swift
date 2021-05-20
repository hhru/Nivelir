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
        completion: @escaping (Result<Output, Error>) -> Void
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

extension ScreenThenable {

    public func first<Output: ScreenContainer>(
        _ predicate: ScreenPredicate<Output>
    ) -> ScreenChildRoute<Root, Output> {
        nest(action: ScreenFirstAction<Then, Output>(predicate: predicate))
    }

    public func first<Output, Route: ScreenThenable>(
        _ predicate: ScreenPredicate<Output>,
        route: Route
    ) -> Self where Route.Root == Output {
        nest(
            action: ScreenFirstAction(predicate: predicate),
            nested: route
        )
    }

    public func first<Output: ScreenContainer>(
        _ predicate: ScreenPredicate<Output>,
        route: (_ route: ScreenRoute<Output>) -> ScreenRoute<Output>
    ) -> Self {
        first(predicate, route: route(.initial))
    }

    public func first<Output: ScreenContainer, Next: ScreenContainer>(
        _ predicate: ScreenPredicate<Output>,
        route: (_ route: ScreenRoute<Output>) -> ScreenChildRoute<Output, Next>
    ) -> Self {
        first(predicate, route: route(.initial))
    }
}

#if canImport(UIKit)
extension ScreenNavigator {

    public func navigate<Container, Route: ScreenThenable>(
        fromFirst predicate: ScreenPredicate<Container>,
        to route: Route,
        completion: Completion? = nil
    ) where Route.Root == Container {
        navigate(
            to: { $0.first(predicate, route: route) },
            completion: completion
        )
    }

    public func navigate<Container: ScreenContainer>(
        fromFirst predicate: ScreenPredicate<Container>,
        to route: (ScreenRoute<Container>) -> ScreenRoute<Container>,
        completion: Completion? = nil
    ) {
        navigate(
            fromFirst: predicate,
            to: route(.initial),
            completion: completion
        )
    }

    public func navigate<Container: ScreenContainer, Next: ScreenContainer>(
        fromFirst predicate: ScreenPredicate<Container>,
        to route: (ScreenRoute<Container>) -> ScreenChildRoute<Container, Next>,
        completion: Completion? = nil
    ) {
        navigate(
            fromFirst: predicate,
            to: route(.initial),
            completion: completion
        )
    }
}
#endif
