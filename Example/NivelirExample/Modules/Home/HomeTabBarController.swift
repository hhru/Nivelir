import UIKit
import Nivelir

final class HomeTabBarController: UITabBarController, ScreenKeyedContainer {

    let screenKey: ScreenKey
    let screenNavigator: ScreenNavigator

    init(screenKey: ScreenKey, screenNavigator: ScreenNavigator) {
        self.screenKey = screenKey
        self.screenNavigator = screenNavigator

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.tintColor = Colors.important
        tabBar.unselectedItemTintColor = Colors.unimportant
    }
}
