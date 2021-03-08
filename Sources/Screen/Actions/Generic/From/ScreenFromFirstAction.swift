import Foundation

public struct ScreenFromFirstAction<
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
        navigation.logger?.info("Searching for a first container of \(Output.self) type in \(container)")

        let first = navigation.iterator.first(in: container) { container in
            guard let container = container as? Output else {
                return false
            }

            return self.predicate.checkContainer(container)
        }

        guard let output = first as? Output else {
            return completion(.failure(ScreenContainerNotFoundError<Output>(for: self)))
        }

        completion(.success(output))
    }
}

extension ScreenRoute {

    public func fromFirst<Output: ScreenContainer>(
        _ predicate: ScreenFromPredicate<Output>,
        to route: ScreenRoute<Output>
    ) -> Self {
        join(
            action: ScreenFromFirstAction<Container, Output>(predicate: predicate),
            route: route
        )
    }

    public func fromFirst<Output: ScreenContainer>(
        _ predicate: ScreenFromPredicate<Output>,
        to route: (_ route: ScreenRoute<Output>) -> ScreenRoute<Output>
    ) -> Self {
        fromFirst(
            predicate,
            to: route(.initial)
        )
    }
}

#if canImport(UIKit)
extension ScreenNavigator {

    public func navigate<Container: ScreenContainer>(
        fromFirst predicate: ScreenFromPredicate<Container>,
        to route: ScreenRoute<Container>,
        completion: Completion? = nil
    ) {
        perform(
            action: ScreenJoinAction(
                first: ScreenFromFirstAction(predicate: predicate),
                second: ScreenNavigateToAction(route: route)
            ),
            completion: completion
        )
    }

    public func navigate<Container: ScreenContainer>(
        fromFirst predicate: ScreenFromPredicate<Container>,
        to route: (ScreenRoute<Container>) -> ScreenRoute<Container>,
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
