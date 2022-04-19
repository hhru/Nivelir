import Foundation

final class ScreenAuthorizeActionBus: AuthorizationContext {

    private var didFinishAuthorizationBox: ((_ isAuthorized: Bool) -> Void)

    init(didFinishAuthorization: @escaping (_ isAuthorized: Bool) -> Void) {
        self.didFinishAuthorizationBox = didFinishAuthorization
    }

    func didFinishAuthorization(isAuthorized: Bool) {
        didFinishAuthorizationBox(isAuthorized)
    }
}
