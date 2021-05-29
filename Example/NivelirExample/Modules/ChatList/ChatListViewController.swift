import UIKit
import Nivelir

final class ChatListViewController: UITableViewController, ScreenKeyedContainer {

    private var chatCount = Int.random(in: 3...10)

    let screenKey: ScreenKey
    let screenNavigator: ScreenNavigator

    init(screenKey: ScreenKey, screenNavigator: ScreenNavigator) {
        self.screenKey = screenKey
        self.screenNavigator = screenNavigator

        super.init(nibName: nil, bundle: nil)

        title = "Chats"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func showChat(id: Int) {
        screenNavigator.navigate(from: stack) { route in
            route.push(ChatScreen(chatID: id))
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Colors.background

        #if os(iOS)
        tableView.separatorStyle = .none
        #endif

        tableView.registerReusableCell(of: ChatListCell.self)
    }

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
        chatCount = Int.random(in: 3...10)
        tableView.reloadData()
    }
}
