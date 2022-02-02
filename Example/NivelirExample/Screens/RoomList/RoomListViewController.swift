import UIKit
import Nivelir

final class RoomListViewController: UITableViewController, ScreenKeyedContainer {

    private let chatCount = Int.random(in: 3...10)

    let authorizationService: AuthorizationService
    let screens: Screens
    let screenKey: ScreenKey
    let screenNavigator: ScreenNavigator

    init(
        authorizationService: AuthorizationService,
        screens: Screens,
        screenKey: ScreenKey,
        screenNavigator: ScreenNavigator
    ) {
        self.authorizationService = authorizationService
        self.screens = screens
        self.screenKey = screenKey
        self.screenNavigator = screenNavigator

        super.init(nibName: nil, bundle: nil)

        self.title = "Rooms"
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func showChatList(roomID: Int) {
        screenNavigator.navigate(to: screens.showChatListRoute(roomID: roomID))
    }

    private func setupTableView() {
        #if os(iOS)
        tableView.separatorStyle = .none
        #endif

        tableView.registerReusableCell(of: RoomListCell.self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Colors.background

        setupTableView()
    }
}

extension RoomListViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        chatCount
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(of: RoomListCell.self, for: indexPath)

        cell.title = "Room #\(indexPath.row)"
        cell.subtitle = "iOS Chats"

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        showChatList(roomID: indexPath.row)
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        72.0
    }
}
