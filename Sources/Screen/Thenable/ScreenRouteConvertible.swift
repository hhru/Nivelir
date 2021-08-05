import Foundation

public protocol ScreenRouteConvertible {
    func route<Container: ScreenContainer>() -> ScreenRootRoute<Container>
}

extension ScreenRoute: ScreenRouteConvertible {

    public func route<Container: ScreenContainer>() -> ScreenRootRoute<Container> {
        ScreenRootRoute(actions: actions as? [AnyScreenAction<Container, Void>] ?? [])
    }
}
