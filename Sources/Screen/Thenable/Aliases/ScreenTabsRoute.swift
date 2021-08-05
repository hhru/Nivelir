#if canImport(UIKit)
import UIKit

// swiftlint:disable:next identifier_name
public let ScreenTabsRoute = ScreenRootRoute<UITabBarController>()

// swiftlint:disable:next identifier_name
public func ScreenTabsRoute(
    _ route: (_ route: ScreenRootRoute<UITabBarController>) -> ScreenRouteConvertible
) -> ScreenRootRoute<UITabBarController> {
    ScreenRootRoute(route)
}
#endif
