import UIKit
import Nivelir

class MainSceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var router: MainSceneRouter?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else {
            return
        }

        let window = UIWindow(windowScene: windowScene)
        let navigator = ScreenNavigator(window: window)

        let router = MainSceneRouter(navigator: navigator)

        self.window = window
        self.router = router

        router.showRootScreen()
        window.makeKeyAndVisible()
    }
}
