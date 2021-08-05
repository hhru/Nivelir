#if canImport(UIKit)
import UIKit

// swiftlint:disable:next identifier_name
public let ScreenModalRoute = ScreenRootRoute<UIViewController>()

// swiftlint:disable:next identifier_name
public func ScreenModalRoute(
    _ route: (_ route: ScreenRootRoute<UIViewController>) -> ScreenRouteConvertible
) -> ScreenRootRoute<UIViewController> {
    ScreenRootRoute(route)
}
#endif
