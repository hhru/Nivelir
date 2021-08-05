#if canImport(UIKit)
import UIKit

// swiftlint:disable:next identifier_name
public let ScreenWindowRoute = ScreenRootRoute<UIWindow>()

// swiftlint:disable:next identifier_name
public func ScreenWindowRoute(
    _ route: (_ route: ScreenRootRoute<UIWindow>) -> ScreenRouteConvertible
) -> ScreenRootRoute<UIWindow> {
    ScreenRootRoute(route)
}
#endif
