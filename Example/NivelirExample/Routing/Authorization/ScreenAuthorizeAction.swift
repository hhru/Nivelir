import Nivelir

struct ScreenAuthorizeAction<Container: UIViewController>: ScreenAction {

    typealias Output = Container

    let services: ScreenAuthorizeActionServices
    let screens: ScreenAuthorizeActionScreens

    init(
        services: ScreenAuthorizeActionServices,
        screens: ScreenAuthorizeActionScreens
    ) {
        self.services = services
        self.screens = screens
    }

    func perform(
        container: Container,
        navigator: ScreenNavigator,
        completion: @escaping Completion
    ) {
        navigator.logInfo("Checking authorization")

        if services.authorizationService().isAuthorized {
            return completion(.success(container))
        }

        let bus = ScreenAuthorizeActionBus { isAuthorized in
            if isAuthorized {
                completion(.success(container))
            } else {
                completion(.failure(ScreenCanceledError(for: self)))
            }
        }

        navigator.registerContext(bus)
        navigator.navigate(to: screens.showAuthorizationRoute())
    }
}

extension ScreenThenable where Current: UIViewController {

    func authorize(
        services: ScreenAuthorizeActionServices,
        screens: ScreenAuthorizeActionScreens
    ) -> Self {
        then(
            ScreenAuthorizeAction<Current>(
                services: services,
                screens: screens
            )
        )
    }
}
