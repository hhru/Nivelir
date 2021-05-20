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
        completion: @escaping (Result<Output, Error>) -> Void
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
    ) -> ScreenChildRoute<Root, Output> {
        nest(action: ScreenLastAction<Then, Output>(predicate: predicate))
    }

    public func last<Output, Route: ScreenThenable>(
        _ predicate: ScreenPredicate<Output>,
        route: Route
    ) -> Self where Route.Root == Output {
        nest(
            action: ScreenLastAction(predicate: predicate),
            nested: route
        )
    }

    public func last<Output: ScreenContainer>(
        _ predicate: ScreenPredicate<Output>,
        route: (_ route: ScreenRoute<Output>) -> ScreenRoute<Output>
    ) -> Self {
        last(predicate, route: route(.initial))
    }

    public func last<Output: ScreenContainer, Next: ScreenContainer>(
        _ predicate: ScreenPredicate<Output>,
        route: (_ route: ScreenRoute<Output>) -> ScreenChildRoute<Output, Next>
    ) -> Self {
        last(predicate, route: route(.initial))
    }
}

#if canImport(UIKit)
extension ScreenNavigator {

    public func navigate<Container, Route: ScreenThenable>(
        fromLast predicate: ScreenPredicate<Container>,
        to route: Route,
        completion: Completion? = nil
    ) where Route.Root == Container {
        navigate(
            to: { $0.last(predicate, route: route) },
            completion: completion
        )
    }

    public func navigate<Container: ScreenContainer>(
        fromLast predicate: ScreenPredicate<Container>,
        to route: (ScreenRoute<Container>) -> ScreenRoute<Container>,
        completion: Completion? = nil
    ) {
        navigate(
            fromLast: predicate,
            to: route(.initial),
            completion: completion
        )
    }

    public func navigate<Container: ScreenContainer, Next: ScreenContainer>(
        fromLast predicate: ScreenPredicate<Container>,
        to route: (ScreenRoute<Container>) -> ScreenChildRoute<Container, Next>,
        completion: Completion? = nil
    ) {
        navigate(
            fromLast: predicate,
            to: route(.initial),
            completion: completion
        )
    }
}
#endif
