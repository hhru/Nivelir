import UIKit
import Nivelir

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    private var services: Services?
    private var screens: Screens?

    private func setupWindow(scene: UIScene) {
        guard let windowScene = scene as? UIWindowScene else {
            return
        }

        let window = UIWindow(windowScene: windowScene)
        let services = Services(window: window)
        let screens = Screens(services: services)

        self.window = window
        self.services = services
        self.screens = screens

        services
            .screenNavigator()
            .navigate(to: screens.showHomeRoute())
    }

    private func setupNavigationBarAppearance() {
        let appearance = UINavigationBar.appearance()

        #if os(iOS)
        appearance.prefersLargeTitles = true
        #endif

        appearance.tintColor = Colors.important
    }

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        setupNavigationBarAppearance()
        setupWindow(scene: scene)
    }
}
