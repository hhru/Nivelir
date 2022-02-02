import UIKit
import Nivelir

struct ChatListScreen: Screen {

    let roomID: Int
    let screens: Screens

    var traits: Set<AnyHashable> {
        [roomID]
    }

    func build(navigator: ScreenNavigator) -> UIViewController {
        ChatListViewController(
            roomID: roomID,
            screens: screens,
            screenKey: key,
            screenNavigator: navigator
        )
    }
}
