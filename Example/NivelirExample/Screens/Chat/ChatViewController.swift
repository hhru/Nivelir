import UIKit
import Nivelir

final class ChatViewController: UIViewController, ScreenKeyedContainer {

    let roomID: Int
    let chatID: Int

    let screenKey: ScreenKey
    let screenNavigator: ScreenNavigator

    init(
        roomID: Int,
        chatID: Int,
        screenKey: ScreenKey,
        screenNavigator: ScreenNavigator
    ) {
        self.roomID = roomID
        self.chatID = chatID

        self.screenKey = screenKey
        self.screenNavigator = screenNavigator

        super.init(nibName: nil, bundle: nil)

        #if os(iOS)
        hidesBottomBarWhenPushed = true
        #endif
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        let chatEmptyView = ChatEmptyView()

        chatEmptyView.title = "Chat \(chatID) in room #\(roomID)"

        view = chatEmptyView
    }
}

extension ChatViewController: ScreenRefreshableContainer {

    func refresh(completion: @escaping () -> Void) {
        print("Refreshed")

        completion()
    }
}
