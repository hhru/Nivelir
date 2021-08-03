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
        guard let output = output else {
            return completion(.containerNotFound(type: Container.self, for: self))
        }

        completion(.success(output))
    }
}

extension ScreenRoute {

    public func from<Output: ScreenContainer>(
        _ container: Output?
    ) -> ScreenRoute<Root, Output> {
        fold(action: ScreenFromAction(output: container))
    }

    public func from<Output: ScreenContainer, Next: ScreenContainer>(
        _ container: Output?,
        to route: ScreenRoute<Output, Next>
    ) -> Self {
        fold(
            action: ScreenFromAction(output: container),
            nested: route
        )
    }

    public func from<Output: ScreenContainer>(
        _ container: Output?,
        _ route: (_ route: ScreenRootRoute<Output>) -> ScreenRouteConvertible
    ) -> Self {
        from(container, to: route(.initial).route())
    }
}

#if canImport(UIKit)
extension ScreenNavigator {

    public func navigate<Output: ScreenContainer, Next: ScreenContainer>(
        from container: Output?,
        to route: ScreenRoute<Output, Next>,
        completion: Completion? = nil
    ) {
        navigate(
            to: { $0.from(container, to: route) },
            completion: completion
        )
    }

    public func navigate<Output: ScreenContainer>(
        from container: Output?,
        to route: (_ route: ScreenRootRoute<Output>) -> ScreenRouteConvertible,
        completion: Completion? = nil
    ) {
        navigate(
            from: container,
            to: route(.initial).route(),
            completion: completion
        )
    }
}
#endif
