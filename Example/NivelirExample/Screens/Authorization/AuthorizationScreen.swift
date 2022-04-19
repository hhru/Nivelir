import UIKit
import Nivelir

struct AuthorizationScreen: Screen {

    let services: Services

    func build(navigator: ScreenNavigator, context: ScreenContext<AuthorizationContext>) -> UIViewController {
        AuthorizationViewController(
            authorizationService: services.authorizationService(),
            screenContext: context,
            screenKey: key,
            screenNavigator: navigator
        )
    }
}
