import Foundation

public struct ScreenFromTopAction<
    Container: ScreenContainer,
    Output: ScreenContainer
>: ScreenAction {

    public let predicate: ScreenFromPredicate<Output>

    public init(predicate: ScreenFromPredicate<Output>) {
        self.predicate = predicate
    }

    public func perform(
        container: Container,
        navigation: ScreenNavigation,
        completion: @escaping (Result<Output, Error>) -> Void
    ) {
        navigation.logger?.info("Searching for a top container of \(Output.self) type in \(container)")

        let top = navigation.iterator.top(in: container) { container in
            guard let container = container as? Output else {
                return false
            }

            return self.predicate.checkContainer(container)
        }

        guard let output = top as? Output else {
            return completion(.failure(ScreenContainerNotFoundError<Output>(for: self)))
        }

        completion(.success(output))
    }
}

extension ScreenRoute {

    public func fromTop<Output: ScreenContainer>(
        _ predicate: ScreenFromPredicate<Output>,
        to route: ScreenRoute<Output>
    ) -> Self {
        join(
            action: ScreenFromTopAction<Container, Output>(predicate: predicate),
            route: route
        )
    }

    public func fromTop<Output: ScreenContainer>(
        _ predicate: ScreenFromPredicate<Output>,
        to route: (_ route: ScreenRoute<Output>) -> ScreenRoute<Output>
    ) -> Self {
        fromTop(
            predicate,
            to: route(.initial)
        )
    }
}

#if canImport(UIKit)
extension ScreenNavigator {

    public func navigate<Container: ScreenContainer>(
        fromTop predicate: ScreenFromPredicate<Container>,
        to route: ScreenRoute<Container>,
        completion: Completion? = nil
    ) {
        perform(
            action: ScreenJoinAction(
                first: ScreenFromTopAction(predicate: predicate),
                second: ScreenNavigateToAction(route: route)
            ),
            completion: completion
        )
    }

    public func navigate<Container: ScreenContainer>(
        fromTop predicate: ScreenFromPredicate<Container>,
        to route: (ScreenRoute<Container>) -> ScreenRoute<Container>,
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
