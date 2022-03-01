import UIKit
import Nivelir

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    private var services: Services?
    private var screens: Screens?

    private func setupNotifications() {
        #if os(iOS)
        let notificationCenter = UNUserNotificationCenter.current()

        notificationCenter.delegate = self

        notificationCenter.requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let error = error {
                print("requestAuthorization() -> error: \(error)")
            } else {
                print("requestAuthorization() -> granted: \(granted)")
            }
        }
        #endif
    }

    private func setupShortcuts() {
        #if os(iOS)
        let firstChatInFirstRoomShortcut = UIApplicationShortcutItem(
            type: "FirstChatInFirstRoom",
            localizedTitle: "Room #1 – Chat 1",
            localizedSubtitle: nil,
            icon: nil,
            userInfo: [
                "room_id": NSNumber(1),
                "chat_id": NSNumber(1)
            ]
        )

        let secondChatInFirstRoomShortcut = UIApplicationShortcutItem(
            type: "SecondChatInFirstRoom",
            localizedTitle: "Room #1 – Chat 2",
            localizedSubtitle: nil,
            icon: nil,
            userInfo: [
                "room_id": NSNumber(1),
                "chat_id": NSNumber(2)
            ]
        )

        let secondChatInSecondRoomShortcut = UIApplicationShortcutItem(
            type: "SecondChatInSecondRoom",
            localizedTitle: "Room #2 – Chat 2",
            localizedSubtitle: nil,
            icon: nil,
            userInfo: [
                "room_id": NSNumber(2),
                "chat_id": NSNumber(2)
            ]
        )

        UIApplication.shared.shortcutItems = [
            firstChatInFirstRoomShortcut,
            secondChatInFirstRoomShortcut,
            secondChatInSecondRoomShortcut
        ]
        #endif
    }

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
        setupShortcuts()
        setupNotifications()
    }

    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        switch userActivity.activityType {
        case NSUserActivityTypeBrowsingWeb:
            guard let url = userActivity.webpageURL else {
                return
            }

            services?
                .deeplinkManager()
                .handleURLIfPossible(url, context: services)

        default:
            break
        }
    }

    func scene(_ scene: UIScene, openURLContexts urlContexts: Set<UIOpenURLContext>) {
        guard let url = urlContexts.first?.url else {
            return
        }

        services?
            .deeplinkManager()
            .handleURLIfPossible(url, context: services)
    }

    #if os(iOS)
    func windowScene(
        _ windowScene: UIWindowScene,
        performActionFor shortcutItem: UIApplicationShortcutItem,
        completionHandler: @escaping (Bool) -> Void
    ) {
        let isHandled = services?
            .deeplinkManager()
            .handleShortcutIfPossible(shortcutItem, context: services) ?? false

        completionHandler(isHandled)
    }
    #endif
}

#if os(iOS)
extension SceneDelegate: UNUserNotificationCenterDelegate {

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        services?
            .deeplinkManager()
            .handleNotificationIfPossible(
                response: response,
                context: services
            )

        completionHandler()
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.list, .banner, .badge, .sound])
    }
}
#endif
