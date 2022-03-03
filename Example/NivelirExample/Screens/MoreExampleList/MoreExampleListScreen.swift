import Nivelir

struct MoreExampleListScreen: Screen {

    let screens: Screens

    func build(navigator: ScreenNavigator) -> UIViewController {
        MoreExampleListViewController(
            screens: screens,
            screenKey: key,
            screenNavigator: navigator
        )
    }
}
