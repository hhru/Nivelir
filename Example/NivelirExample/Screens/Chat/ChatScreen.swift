import UIKit
import Nivelir

struct ChatScreen: Screen {

    let roomID: Int
    let chatID: Int

    var traits: Set<AnyHashable> {
        [roomID, chatID]
    }

    func build(navigator: ScreenNavigator) -> UIViewController {
        ChatViewController(
            roomID: roomID,
            chatID: chatID,
            screenKey: key,
            screenNavigator: navigator
        )
    }
}
