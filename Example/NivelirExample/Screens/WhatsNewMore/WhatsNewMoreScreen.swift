import UIKit
import Nivelir

struct WhatsNewMoreScreen: Screen {

    func build(navigator: ScreenNavigator) -> UIViewController {
        WhatsNewMoreViewController(
            screenKey: key,
            screenNavigator: navigator
        )
    }
}
