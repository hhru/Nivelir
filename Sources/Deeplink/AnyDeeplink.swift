import Foundation

public protocol AnyDeeplink {

    func navigateIfPossible(using routes: Any)
}
