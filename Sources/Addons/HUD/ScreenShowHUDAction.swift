#if canImport(UIKit)
import UIKit

/// Action to show ``HUD``.
public struct ScreenShowHUDAction<Container: ScreenContainer>: ScreenAction {

    public typealias Output = Void

    public let hud: HUD
    public let animation: HUDAnimation?
    public let duration: TimeInterval?

    public init(
        hud: HUD,
        animation: HUDAnimation? = .default,
        duration: TimeInterval? = nil
    ) {
        self.hud = hud
        self.animation = animation
        self.duration = duration
    }

    public func perform(
        container: Container,
        navigator: ScreenNavigator,
        completion: @escaping Completion
    ) {
        navigator.logInfo("Presenting \(hud) on \(type(of: container))")

        guard let window = navigator.window else {
            return completion(.containerNotFound(type: UIWindow.self, for: self))
        }

        HUD.show(hud, in: window, animation: animation, duration: duration) {
            completion(.success)
        }
    }
}

extension ScreenThenable {

    /// Adds the specified hud to window and displays it.
    /// The counterpart of this method is ``ScreenThenable/hideHUD()``.
    /// - Parameters:
    ///   - hud: A representation of a HUD.
    ///   - animation: The animation type that should be used when the HUD is shown and hidden.
    ///   The default is ``HUDAnimation/default``.
    ///   - duration: Duration of HUD display in seconds.
    ///   After this time has elapsed, the HUD will be hidden.
    ///   By default `nil`, the HUD will not be hidden.
    /// - Returns: An instance containing the new action.
    public func showHUD(
        _ hud: HUD,
        animation: HUDAnimation? = .default,
        duration: TimeInterval? = nil
    ) -> Self {
        then(
            ScreenShowHUDAction<Current>(
                hud: hud,
                animation: animation,
                duration: duration
            )
        )
    }
}
#endif
