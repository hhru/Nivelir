#if canImport(UIKit)
import UIKit

// swiftlint:disable:next identifier_name
public let ScreenStackRoute = ScreenRootRoute<UINavigationController>()

// swiftlint:disable:next identifier_name
public func ScreenStackRoute(
    _ route: (_ route: ScreenRootRoute<UINavigationController>) -> ScreenRouteConvertible
) -> ScreenRootRoute<UINavigationController> {
    ScreenRootRoute(route)
}
#endif
