#if canImport(UIKit)
import UIKit

/// A type that provides an instance of `UIWindow` for navigating and searching containers.
public protocol ScreenWindowProvider {

    /// The `UIWindow` for navigating and searching for containers.
    var window: UIWindow? { get }
}
#endif
