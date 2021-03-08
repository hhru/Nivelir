import Foundation

public struct ScreenFromAction<
    Container: ScreenContainer,
    Output: ScreenContainer
>: ScreenAction {

    public let output: Output?

    public init(output: Output?) {
        self.output = output
    }

    public func perform(
        container: Container,
        navigation: ScreenNavigation,
        completion: @escaping (Result<Output, Error>) -> Void
    ) {
        navigation.logger?.info("Resolving container of \(Output.self) type")

        guard let output = output else {
            return completion(.failure(ScreenContainerNotFoundError<Output>(for: self)))
        }

        completion(.success(output))
    }
}

extension ScreenRoute {

    public func from<Output: ScreenContainer>(
        _ container: Output?,
        to route: ScreenRoute<Output>
    ) -> Self {
        join(
            action: ScreenFromAction<Container, Output>(output: container),
            route: route
        )
    }

    public func from<Output: ScreenContainer>(
        _ container: Output?,
        to route: (_ route: ScreenRoute<Output>) -> ScreenRoute<Output>
    ) -> Self {
        from(
            container,
            to: route(.initial)
        )
    }
}

#if canImport(UIKit)
extension ScreenNavigator {

    public func navigate<Container: ScreenContainer>(
        from container: Container?,
        to route: ScreenRoute<Container>,
        completion: Completion? = nil
    ) {
        perform(
            action: ScreenJoinAction(
                first: ScreenFromAction(output: container),
                second: ScreenNavigateToAction(route: route)
            ),
            completion: completion
        )
    }

    public func navigate<Container: ScreenContainer>(
        from container: Container?,
        to route: (ScreenRoute<Container>) -> ScreenRoute<Container>,
        completion: Completion? = nil
    ) {
        navigate(
            from: container,
            to: route(.initial),
            completion: completion
        )
    }
}
#endif
