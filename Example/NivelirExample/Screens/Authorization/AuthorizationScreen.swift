import UIKit
import Nivelir

struct AuthorizationScreen: Screen {

    let services: Services

    func build(
        navigator: ScreenNavigator,
        observation: ScreenObservation<AuthorizationObserver>
    ) -> UIViewController {
        AuthorizationViewController(
            authorizationService: services.authorizationService(),
            screenObservation: observation,
            screenKey: key,
            screenNavigator: navigator
        )
    }
}
