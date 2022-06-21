#if canImport(UIKit)
import UIKit

public struct ScreenKeyWindowProvider: ScreenWindowProvider {

    public var window: UIWindow? {
        UIApplication.shared.firstKeyWindow
    }

    public init() { }
}
#endif
