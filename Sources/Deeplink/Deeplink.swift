import Foundation

public protocol Deeplink: AnyDeeplink {

    associatedtype Routes

    func navigate(using routes: Routes)
}

extension Deeplink {

    public func navigateIfPossible(using routes: Any) {
        guard let routes = routes as? Routes else {
            return
        }

        navigate(using: routes)
    }
}
