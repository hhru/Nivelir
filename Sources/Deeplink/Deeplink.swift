import Foundation

public protocol Deeplink: AnyDeeplink {

    associatedtype Routes

    func navigate(
        using routes: Routes,
        navigator: ScreenNavigator
    )
}

extension Deeplink {

    public func navigateIfPossible(using routes: Any, navigator: ScreenNavigator) {
        guard let routes = routes as? Routes else {
            return
        }

        navigate(
            using: routes,
            navigator: navigator
        )
    }
}
