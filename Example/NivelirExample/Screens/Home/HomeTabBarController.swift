import UIKit
import Nivelir

final class HomeTabBarController: UITabBarController, ScreenKeyedContainer {

    let deeplinkManager: DeeplinkManager
    let screens: Screens
    let screenKey: ScreenKey
    let screenNavigator: ScreenNavigator

    init(
        deeplinkManager: DeeplinkManager,
        screens: Screens,
        screenKey: ScreenKey,
        screenNavigator: ScreenNavigator
    ) {
        self.deeplinkManager = deeplinkManager
        self.screens = screens
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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        deeplinkManager.activate(screens: screens)
    }
}
