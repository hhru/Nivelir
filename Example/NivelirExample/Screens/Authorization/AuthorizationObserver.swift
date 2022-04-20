import Foundation

public protocol AuthorizationObserver: AnyObject {

    func didFinishAuthorization(isAuthorized: Bool)
}
