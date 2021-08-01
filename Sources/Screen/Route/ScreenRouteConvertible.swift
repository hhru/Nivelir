import Foundation

public protocol ScreenRouteConvertible {
    func route<Container: ScreenContainer>() -> ScreenRootRoute<Container>
}
