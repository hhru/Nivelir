import UIKit
import Nivelir

final class ChatViewController: UIViewController, ScreenKeyedContainer {

    let chatID: Int

    let screenKey: ScreenKey
    let screenNavigator: ScreenNavigator

    init(chatID: Int, screenKey: ScreenKey, screenNavigator: ScreenNavigator) {
        self.chatID = chatID

        self.screenKey = screenKey
        self.screenNavigator = screenNavigator

        super.init(nibName: nil, bundle: nil)

        #if os(iOS)
        hidesBottomBarWhenPushed = true
        #endif
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        let chatEmptyView = ChatEmptyView()

        chatEmptyView.title = "Chat \(chatID)"

        view = chatEmptyView
    }
}

extension ChatViewController: ScreenRefreshableContainer {

    func refresh(completion: @escaping () -> Void) {
        print("Refreshed")

        completion()
    }
}
