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
        navigator: ScreenNavigator,
        completion: @escaping Completion
    ) {
        navigator.logInfo("Resolving container of \(Output.self) type")

        guard let output = output else {
            return completion(.containerNotFound(type: Container.self, for: self))
        }

        completion(.success(output))
    }
}

extension ScreenThenable {

    public func from<Output: ScreenContainer>(
        _ container: Output?
    ) -> ScreenChildRoute<Root, Output> {
        nest(action: ScreenFromAction<Then, Output>(output: container))
    }

    public func from<Route: ScreenThenable>(
        _ container: Route.Root?,
        to route: Route
    ) -> Self {
        nest(
            action: ScreenFromAction(output: container),
            nested: route
        )
    }

    public func from<Output: ScreenContainer>(
        _ container: Output?,
        _ route: (_ route: ScreenRoute<Output>) -> ScreenRoute<Output>
    ) -> Self {
        from(container, to: route(.initial))
    }

    public func from<Output: ScreenContainer, Next: ScreenContainer>(
        _ container: Output?,
        _ route: (_ route: ScreenRoute<Output>) -> ScreenChildRoute<Output, Next>
    ) -> Self {
        from(container, to: route(.initial))
    }
}

#if canImport(UIKit)
extension ScreenNavigator {

    public func navigate<Container, Route: ScreenThenable>(
        from container: Container?,
        to route: Route,
        completion: Completion? = nil
    ) where Route.Root == Container {
        navigate(
            to: { $0.from(container, to: route) },
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

    public func navigate<Container: ScreenContainer, Next: ScreenContainer>(
        from container: Container?,
        to route: (ScreenRoute<Container>) -> ScreenChildRoute<Container, Next>,
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
