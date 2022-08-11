import Foundation

/// A type describing the navigation of a deep link.
///
/// The ``Deeplink`` in Nivelir is responsible for opening a specific screen
/// in the application by URL, Push Notification or Shortcut.
///
/// `Deeplink` has an associated type ``Screens``, which is a navigation helper type that should be a screen factory.
/// From this factory are created the necessary screens to make the navigation.
///
/// - Note: The type of the associated type ``Screens`` must match the type
/// of the implementation passed to the `screens` parameter
/// when activated using the ``DeeplinkManager/activate(screens:scope:)`` method.
///
/// - SeeAlso: ``DeeplinkManager``
public protocol Deeplink: AnyDeeplink {

    /// Type of screen factory.
    associatedtype Screens

    /// Navigating to the screen.
    /// - Parameters:
    ///   - screens: Screen Factory.
    ///   - navigator: Navigator for performing navigation actions.
    ///   - handler: Handler for processing a new ``Deeplink``
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
