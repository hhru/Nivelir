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

    func authorizationService() -> AuthorizationService {
        container.shared {
            DefaultAuthorizationService()
        }
    }
}

extension Services: ScreenAuthorizeActionServices { }
