import UIKit
import Nivelir

struct Services {

    private let container = ServiceContainer()

    let window: UIWindow

    func screenNavigator() -> ScreenNavigator {
        container.shared {
            ScreenNavigator(window: window)
        }
    }

    func deeplinkManager() -> DeeplinkManager {
        container.shared {
            DeeplinkManager(
                deeplinkTypes: [
                    ChatDeeplink.self
                ],
                navigator: screenNavigator()
            )
        }
    }

    func authorizationService() -> AuthorizationService {
        container.shared {
            DefaultAuthorizationService()
        }
    }

    func profileService() -> ProfileService {
        DefaultProfileService(authorizationService: authorizationService())
    }
}

extension Services: ScreenAuthorizeActionServices { }
