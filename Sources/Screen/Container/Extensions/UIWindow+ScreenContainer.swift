#if canImport(UIKit)
import UIKit

extension UIWindow: ScreenVisibleContainer {

    /// A Boolean value indicating whether the container is visible.
    ///
    /// Returns `true` if the window is not hidden.
    public var isVisible: Bool {
        !isHidden
    }
}
#endif
