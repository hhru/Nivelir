#if canImport(UIKit)
import UIKit

public protocol ScreenWindowProvider {

    var window: UIWindow? { get }
}
#endif
