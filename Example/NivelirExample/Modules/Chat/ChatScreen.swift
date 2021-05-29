import UIKit
import Nivelir

struct ChatScreen: Screen {

    let chatID: Int

    var traits: Set<AnyHashable> {
        [chatID]
    }

    func build(navigator: ScreenNavigator) -> UIViewController {
        ChatViewController(
            chatID: chatID,
            screenKey: key,
            screenNavigator: navigator
        )
    }
}
