import UIKit
import Nivelir

struct ProfileScreen: Screen {

    let services: Services
    let screens: Screens

    func build(navigator: ScreenNavigator) -> UIViewController {
        ProfileViewController(
            authorizationService: services.authorizationService(),
            profileService: services.profileService(),
            screens: screens,
            screenKey: key,
            screenNavigator: navigator
        )
    }
}
