import UIKit
import Nivelir

final class ChatListViewController: UITableViewController, ScreenKeyedContainer {

    private let chatCount = Int.random(in: 3...10)

    let roomID: Int
    let screens: Screens
    let screenKey: ScreenKey
    let screenNavigator: ScreenNavigator

    init(
        roomID: Int,
        screens: Screens,
        screenKey: ScreenKey,
        screenNavigator: ScreenNavigator
    ) {
        self.roomID = roomID
        self.screens = screens
        self.screenKey = screenKey
        self.screenNavigator = screenNavigator

        super.init(nibName: nil, bundle: nil)

        title = "Chats – Room #\(roomID)"
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func onCloseBarButtonTouchUpInside() {
        screenNavigator.navigate(from: presenting) { route in
            route.dismiss()
        }
    }

    private func showChat(id: Int) {
        screenNavigator.navigate(
            to: screens.showChatRoute(
                roomID: roomID,
                chatID: id
            )
        )
    }

    private func setupCloseBarButton() {
        let closeBarBattonItem = UIBarButtonItem(
            image: Images.close,
            style: .plain,
            target: self,
            action: #selector(onCloseBarButtonTouchUpInside)
        )

        closeBarBattonItem.tintColor = Colors.important

        navigationItem.leftBarButtonItem = closeBarBattonItem
    }

    private func setupTableView() {
        #if os(iOS)
        tableView.separatorStyle = .none
        #endif

        tableView.registerReusableCell(of: ChatListCell.self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Colors.background

        setupCloseBarButton()
        setupTableView()
    }
}

extension ChatListViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        chatCount
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(of: ChatListCell.self, for: indexPath)

        cell.title = "Chat \(indexPath.row)"
        cell.subtitle = "Empty chat"

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        showChat(id: indexPath.item)
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        72.0
    }
}

extension ChatListViewController: ScreenRefreshableContainer {

    func refresh(completion: @escaping () -> Void) {
        tableView.reloadData()

        completion()
    }
}
