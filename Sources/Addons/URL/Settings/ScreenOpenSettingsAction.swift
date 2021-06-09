#if canImport(UIKit)
import UIKit

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

extension ScreenRoute {

    public func openAppSettings() -> Self {
        then(ScreenOpenSettingsAction())
    }
}
#endif
