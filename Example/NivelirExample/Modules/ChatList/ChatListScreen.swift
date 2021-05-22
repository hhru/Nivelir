import UIKit
import Nivelir

struct ChatListScreen: Screen {

    func build(navigator: ScreenNavigator) -> UIViewController {
        ChatListViewController(
            screenKey: key,
            screenNavigator: navigator
        )
    }
}
