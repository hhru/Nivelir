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
    ) -> ScreenSubroute<Root, Output> {
        nest(action: ScreenTopAction<Then, Output>(predicate: predicate))
    }

    public func top<Output, Route: ScreenThenable>(
        _ predicate: ScreenPredicate<Output>,
        route: Route
    ) -> Self where Route.Root == Output {
        nest(
            action: ScreenTopAction(predicate: predicate),
            nested: route
        )
    }

    public func top<Output: ScreenContainer>(
        _ predicate: ScreenPredicate<Output>,
        route: (_ route: ScreenRoute<Output>) -> ScreenRoute<Output>
    ) -> Self {
        top(predicate, route: route(.initial))
    }

    public func top<Output: ScreenContainer, Next: ScreenContainer>(
        _ predicate: ScreenPredicate<Output>,
        route: (_ route: ScreenRoute<Output>) -> ScreenSubroute<Output, Next>
    ) -> Self {
        top(predicate, route: route(.initial))
    }
}

#if canImport(UIKit)
extension ScreenNavigator {

    public func navigate<Container, Route: ScreenThenable>(
        fromTop predicate: ScreenPredicate<Container>,
        to route: Route,
        completion: Completion? = nil
    ) where Route.Root == Container {
        navigate(
            to: { $0.top(predicate, route: route) },
            completion: completion
        )
    }

    public func navigate<Container: ScreenContainer>(
        fromTop predicate: ScreenPredicate<Container>,
        to route: (ScreenRoute<Container>) -> ScreenRoute<Container>,
        completion: Completion? = nil
    ) {
        navigate(
            fromTop: predicate,
            to: route(.initial),
            completion: completion
        )
    }

    public func navigate<Container: ScreenContainer, Next: ScreenContainer>(
        fromTop predicate: ScreenPredicate<Container>,
        to route: (ScreenRoute<Container>) -> ScreenSubroute<Container, Next>,
        completion: Completion? = nil
    ) {
        navigate(
            fromTop: predicate,
            to: route(.initial),
            completion: completion
        )
    }
}
#endif
