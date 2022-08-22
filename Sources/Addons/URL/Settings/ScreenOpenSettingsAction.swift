#if canImport(UIKit)
import UIKit

/// Action to open the system settings of the application.
public struct ScreenOpenSettingsAction<Container: ScreenContainer>: ScreenAction {

    public typealias Output = Void

    public init() { }

    public func perform(
        container: Container,
        navigator: ScreenNavigator,
        completion: @escaping Completion
    ) {
        guard let url = URL(string: UIApplication.openSettingsURLString) else {
            return completion(.invalidOpenSettingsURL(for: self))
        }

        ScreenOpenURLAction(url: url).perform(
            container: container,
            navigator: navigator,
            completion: completion
        )
    }
}

extension ScreenThenable {

    /// The system launches the Settings app and displays the app’s custom settings, if it has any.
    /// - Returns: An instance containing the new action.
    public func openAppSettings() -> Self {
        then(ScreenOpenSettingsAction())
    }
}
#endif
