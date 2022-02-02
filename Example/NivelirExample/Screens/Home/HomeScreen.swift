import Foundation
import Nivelir

struct HomeScreen: Screen {

    let services: Services
    let screens: Screens

    func build(navigator: ScreenNavigator) -> UITabBarController {
        let view = HomeTabBarController(
            deeplinkManager: services.deeplinkManager(),
            screens: screens,
            screenKey: key,
            screenNavigator: navigator
        )

        navigator.navigate(from: view) { route in
            route
                .setupTab(
                    with: screens
                        .roomListScreen()
                        .withStackContainer()
                        .withTabBarItem(.rooms)
                )
                .setupTab(
                    with: screens
                        .profileScreen()
                        .withStackContainer()
                        .withTabBarItem(.profile)
                )
                .selectTab(with: .index(0))
        }

        return view
    }
}
