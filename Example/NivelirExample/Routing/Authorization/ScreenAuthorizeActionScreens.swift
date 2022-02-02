import Foundation
import Nivelir

protocol ScreenAuthorizeActionScreens {

    func showAuthorizationRoute(
        completion: @escaping (_ isAuthorized: Bool) -> Void
    ) -> ScreenWindowRoute
}
