import UIKit
import Nivelir

struct AuthorizationScreen: Screen {

    let completion: (_ isAuthorized: Bool) -> Void
    let services: Services

    func build(navigator: ScreenNavigator) -> UIViewController {
        AuthorizationViewController(
            authorizationCompletion: completion,
            authorizationService: services.authorizationService(),
            screenKey: key,
            screenNavigator: navigator
        )
    }
}
