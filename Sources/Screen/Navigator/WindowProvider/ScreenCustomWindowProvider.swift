#if canImport(UIKit)
import UIKit

/// An implementation of `ScreenWindowProvider` that provides a `UIWindow` explicitly passed through the initializer.
public struct ScreenCustomWindowProvider: ScreenWindowProvider {

    /// The `UIWindow` for navigating and searching for containers.
    public private(set) weak var window: UIWindow?

    public init(window: UIWindow) {
        self.window = window
    }
}
#endif
