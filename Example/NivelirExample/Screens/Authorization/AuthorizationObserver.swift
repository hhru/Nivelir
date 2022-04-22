import Foundation

public protocol AuthorizationObserver: AnyObject {

    func authorizationFinished(isAuthorized: Bool)
}
