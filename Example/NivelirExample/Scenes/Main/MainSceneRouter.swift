import UIKit
import Nivelir

final class MainSceneRouter {

    let navigator: ScreenNavigator

    init(navigator: ScreenNavigator) {
        self.navigator = navigator
    }

    func showRootScreen() {
        navigator.navigate { route in
            route.setRoot(to: HomeScreen())
        }
    }
}
