import Foundation

/// Erased type of ``Deeplink`` protocol.
///
/// - SeeAlso: ``Deeplink``
public protocol AnyDeeplink {

    /// The default implementation casts `screens` to the ``Deeplink/Screens`` type
    /// and performs ``Deeplink/navigate(screens:navigator:handler:)`` navigation.
    /// - Parameters:
    ///   - screens: Screen Factory.
    ///   - navigator: Navigator for performing navigation actions.
    ///   - handler: Handler for processing a new ``Deeplink``.
    func navigateIfPossible(
        screens: Any?,
        navigator: ScreenNavigator,
        handler: DeeplinkHandler
    ) throws
}
