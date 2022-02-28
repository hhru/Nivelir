import Nivelir

struct MoreExampleListScreen: Screen {

    func build(navigator: ScreenNavigator) -> UIViewController {
        MoreExampleListViewController(
            screenKey: key,
            screenNavigator: navigator
        )
    }
}
