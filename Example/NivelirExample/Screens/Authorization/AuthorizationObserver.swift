import Foundation
import Nivelir

@MainActor
public protocol AuthorizationObserver: ScreenObserver {

    func authorizationFinished(isAuthorized: Bool)
}
