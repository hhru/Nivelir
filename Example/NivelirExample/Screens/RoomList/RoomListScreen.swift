import UIKit
import Nivelir

struct RoomListScreen: Screen {

    let services: Services
    let screens: Screens

    func build(navigator: ScreenNavigator) -> UIViewController {
        RoomListViewController(
            authorizationService: services.authorizationService(),
            screens: screens,
            screenKey: key,
            screenNavigator: navigator
        )
    }
}
