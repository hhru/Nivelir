import Foundation
import Nivelir

struct Screens {

    let services: Services

    // MARK: - Screens

    func homeScreen() -> AnyTabsScreen {
        HomeScreen(
            services: services,
            screens: self
        ).eraseToAnyScreen()
    }

    func roomListScreen() -> AnyModalScreen {
        RoomListScreen(
            services: services,
            screens: self
        ).eraseToAnyScreen()
    }

    func chatListScreen(roomID: Int) -> AnyModalScreen {
        ChatListScreen(
            roomID: roomID,
            screens: self
        ).eraseToAnyScreen()
    }

    func chatScreen(roomID: Int, chatID: Int) -> AnyModalScreen {
        ChatScreen(
            roomID: roomID,
            chatID: chatID
        ).eraseToAnyScreen()
    }

    func profileScreen() -> AnyModalScreen {
        ProfileScreen(
            services: services,
            screens: self
        ).eraseToAnyScreen()
    }

    func authorizationScreen() -> AnyModalScreen {
        AuthorizationScreen(
            services: services
        ).eraseToAnyScreen()
    }

    func whatsNewScreen() -> AnyModalScreen {
        WhatsNewScreen(
            screens: self
        ).eraseToAnyScreen()
    }

    #if os(iOS)
    func whatsNewMoreScreen() -> AnyModalScreen {
        WhatsNewMoreScreen().eraseToAnyScreen()
    }

    func moreExampleListScreen() -> AnyModalScreen {
        MoreExampleListScreen(
            screens: self
        ).eraseToAnyScreen()
    }

    func landmarkScreen() -> AnyModalScreen {
        LandmarkScreen().eraseToAnyScreen()
    }
    #endif

    // MARK: - Routes

    func showHomeRoute() -> ScreenWindowRoute {
        ScreenWindowRoute()
            .setRoot(to: homeScreen())
            .makeKeyAndVisible()
    }

    func showRoomListRoute() -> ScreenWindowRoute {
        ScreenWindowRoute()
            .last(.container(key: roomListScreen().key))
            .makeVisible()
            .fallback(to: showHomeRoute())
    }

    func showProfileRoute() -> ScreenWindowRoute {
        ScreenWindowRoute()
            .last(.container(key: profileScreen().key))
            .makeVisible()
            .fallback(to: showHomeRoute())
    }

    func showChatListRoute(roomID: Int) -> ScreenWindowRoute {
        let screen = chatListScreen(roomID: roomID)

        return ScreenWindowRoute()
            .last(.container(key: screen.key))
            .makeVisible()
            .fallback(
                to: showRoomListRoute()
                    .top(.container)
                    .authorize(services: services, screens: self)
                    .present(screen.withStackContainer())
            )
    }

    func showChatRoute(roomID: Int, chatID: Int) -> ScreenWindowRoute {
        let screen = chatScreen(roomID: roomID, chatID: chatID)

        return ScreenWindowRoute()
            .last(.container(key: screen.key))
            .makeVisible()
            .refresh()
            .fallback(
                to: showChatListRoute(roomID: roomID)
                    .top(.stack)
                    .push(screen)
            )
    }

    func showAuthorizationRoute() -> ScreenWindowRoute {
        ScreenWindowRoute()
            .top(.container)
            .present(authorizationScreen().withStackContainer())
            .resolve()
    }
}

extension Screens: ScreenAuthorizeActionScreens { }
