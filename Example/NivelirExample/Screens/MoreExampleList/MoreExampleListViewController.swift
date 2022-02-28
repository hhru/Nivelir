import UIKit
import Nivelir

final class MoreExampleListViewController: UITableViewController, ScreenKeyedContainer {

    private var models: [MoreExampleListModel] = []

    let screenKey: ScreenKey
    let screenNavigator: ScreenNavigator

    init(screenKey: ScreenKey, screenNavigator: ScreenNavigator) {
        self.screenKey = screenKey
        self.screenNavigator = screenNavigator

        super.init(nibName: nil, bundle: nil)

        self.title = "More Examples"
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func showSwiftUIExample() {
        // Handle
    }

    private func setupModels() {
        models = [
            MoreExampleListModel(title: "SwiftUI Example") { [unowned self] in
                self.showSwiftUIExample()
            }
        ]
    }

    private func setupTableView() {
        #if os(iOS)
        tableView.separatorStyle = .none
        #endif

        tableView.registerReusableCell(of: MoreExampleListCell.self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Colors.background

        setupModels()
        setupTableView()
    }
}

extension MoreExampleListViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        models.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(of: MoreExampleListCell.self, for: indexPath)

        cell.title = models[indexPath.row].title

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        models[indexPath.row].didSelectHandler()
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        52.0
    }
}
