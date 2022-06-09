import Foundation
import Nivelir

public protocol AuthorizationObserver: ScreenObserver {

    func authorizationFinished(isAuthorized: Bool)
}
