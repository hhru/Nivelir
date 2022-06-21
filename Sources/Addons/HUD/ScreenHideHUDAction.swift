#if canImport(UIKit)
import UIKit

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

    public func hideHUD() -> Self {
        then(ScreenHideHUDAction<Current>())
    }
}
#endif
