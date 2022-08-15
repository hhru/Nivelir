#if canImport(UIKit)
import UIKit

/// Action to hide the currently displayed ``HUD``.
public struct ScreenHideHUDAction<Container: ScreenContainer>: ScreenAction {

    public typealias Output = Void

    public init() { }

    public func perform(
        container: Container,
        navigator: ScreenNavigator,
        completion: @escaping Completion
    ) {
        navigator.logInfo("Dismissing HUD presented by \(type(of: container))")

        guard let window = navigator.window else {
            return completion(.containerNotFound(type: UIWindow.self, for: self))
        }

        HUD.hide(in: window) {
            completion(.success)
        }
    }
}

extension ScreenThenable {

    /// Finds the top-most HUD subview in window of navigator that hasn’t finished and hides it.
    /// The counterpart to this method is ``ScreenThenable/showHUD(_:animation:duration:)``.
    /// - Returns: An instance containing the new action.
    public func hideHUD() -> Self {
        then(ScreenHideHUDAction<Current>())
    }
}
#endif
