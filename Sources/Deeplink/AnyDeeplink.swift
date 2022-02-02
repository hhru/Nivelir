import Foundation

public protocol AnyDeeplink {

    func navigateIfPossible(
        screens: Any?,
        navigator: ScreenNavigator,
        handler: DeeplinkHandler
    ) throws
}
