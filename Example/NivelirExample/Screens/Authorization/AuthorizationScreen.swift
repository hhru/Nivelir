import UIKit
import Nivelir

struct AuthorizationScreen: Screen {

    let services: Services

    func build(
        navigator: ScreenNavigator,
        observer: ScreenObserver<AuthorizationObserver>
    ) -> UIViewController {
        AuthorizationViewController(
            authorizationService: services.authorizationService(),
            screenObserver: observer,
            screenKey: key,
            screenNavigator: navigator
        )
    }
}
