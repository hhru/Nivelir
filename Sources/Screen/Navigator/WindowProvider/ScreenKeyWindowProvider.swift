#if canImport(UIKit)
import UIKit

public struct ScreenKeyWindowProvider: ScreenWindowProvider {

    public var window: UIWindow? {
        if #available(iOS 13, *) {
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.keyWindow
        }
    }

    public init() { }
}
#endif
