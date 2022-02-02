import Foundation

public protocol Deeplink: AnyDeeplink {

    associatedtype Screens

    func navigate(
        screens: Screens,
        navigator: ScreenNavigator,
        handler: DeeplinkHandler
    ) throws
}

// MARK: - Screens resolving

extension Deeplink where Screens: Nullable {

    private func resolveScreens(_ screens: Any?) throws -> Screens {
        guard let screens = screens else {
            return .none
        }

        guard let deeplinkScreens = screens as? Screens else {
            throw DeeplinkInvalidScreensError(
                screens: screens,
                type: Screens.self,
                for: self
            )
        }

        return deeplinkScreens
    }
}

extension Deeplink {

    private func resolveScreens(_ screens: Any?) throws -> Screens {
        guard let deeplinkScreens = screens as? Screens else {
            throw DeeplinkInvalidScreensError(
                screens: screens,
                type: Screens.self,
                for: self
            )
        }

        return deeplinkScreens
    }
}

// MARK: - Default implementation

extension Deeplink {

    public func navigateIfPossible(
        screens: Any?,
        navigator: ScreenNavigator,
        handler: DeeplinkHandler
    ) throws {
        try navigate(
            screens: resolveScreens(screens),
            navigator: navigator,
            handler: handler
        )
    }
}
