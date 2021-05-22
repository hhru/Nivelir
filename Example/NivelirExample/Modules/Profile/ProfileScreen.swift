import UIKit
import Nivelir

struct ProfileScreen: Screen {

    func build(navigator: ScreenNavigator) -> UIViewController {
        ProfileViewController(
            screenKey: key,
            screenNavigator: navigator
        )
    }
}
