import Foundation

public protocol AuthorizationContext: AnyObject {

    func didFinishAuthorization(isAuthorized: Bool)
}
