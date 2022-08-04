#if canImport(UIKit)
import UIKit

/// An implementation of `ScreenWindowProvider` providing the first found key `UIWindow`.
public struct ScreenKeyWindowProvider: ScreenWindowProvider {

    /// The `UIWindow` for navigating and searching for containers.
    public var window: UIWindow? {
        UIApplication.shared.firstKeyWindow
    }

    public init() { }
}
#endif
