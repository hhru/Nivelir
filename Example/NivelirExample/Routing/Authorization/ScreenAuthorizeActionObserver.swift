import Foundation

final class ScreenAuthorizeActionObserver: AuthorizationObserver {

    private var authorizationFinishedHandler: ((_ isAuthorized: Bool) -> Void)

    init(authorizationFinishedHandler: @escaping (_ isAuthorized: Bool) -> Void) {
        self.authorizationFinishedHandler = authorizationFinishedHandler
    }

    func authorizationFinished(isAuthorized: Bool) {
        authorizationFinishedHandler(isAuthorized)
    }
}
