import Foundation

public protocol AnyDeeplink {

    func navigateIfPossible(routes: Any?, handler: DeeplinkHandler) throws
}
