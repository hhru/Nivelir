import Foundation

#if canImport(UIKit)
import UIKit
#endif

/// A screen container that can be visible.
///
/// This is a simple protocol that is used to determine the visibility of a container.
/// The `UIWindow` and `UIViewController` classes and all their subclasses already implement this protocol
///
/// - SeeAlso: `ScreenContainer`
public protocol ScreenVisibleContainer: ScreenContainer {

    /// A Boolean value indicating whether the container is visible.
    var isVisible: Bool { get }

    #if canImport(UIKit)
    /// The scene containing the container.
    @available(iOS 13.0, tvOS 13.0, *)
    var windowScene: UIWindowScene? { get }
    #endif
}
