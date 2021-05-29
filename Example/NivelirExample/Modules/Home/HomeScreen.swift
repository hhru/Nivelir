import Foundation
import Nivelir

struct HomeScreen: Screen {

    func build(navigator: ScreenNavigator) -> UITabBarController {
        let view = HomeTabBarController(
            screenKey: key,
            screenNavigator: navigator
        )

        navigator.navigate(from: view) { route in
            route
                .setupTab(
                    with: ChatListScreen()
                        .withStackContainer()
                        .withTabBarItem(.chats)
                )
                .setupTab(
                    with: ProfileScreen()
                        .withStackContainer()
                        .withTabBarItem(.profile)
                )
                .selectTab(with: .index(0))
        }

        return view
    }
}
