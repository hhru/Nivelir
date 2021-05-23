import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    private func setupNavigationBarAppearance() {
        let appearance = UINavigationBar.appearance()

        #if os(iOS)
        appearance.prefersLargeTitles = true
        #endif

        appearance.tintColor = Colors.important
    }

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        setupNavigationBarAppearance()

        return true
    }

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        UISceneConfiguration(
            name: "Main",
            sessionRole: connectingSceneSession.role
        )
    }
}
