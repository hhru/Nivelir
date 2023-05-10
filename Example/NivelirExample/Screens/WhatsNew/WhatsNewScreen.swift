import UIKit
import Nivelir

struct WhatsNewScreen: Screen {

    let screens: Screens

    func build(navigator: ScreenNavigator) -> UIViewController {
        WhatsNewViewController(
            screens: screens,
            screenKey: key,
            screenNavigator: navigator
        )
    }
}
