#if canImport(UIKit)
import UIKit

extension UIViewController: ScreenVisibleContainer {

    /// A Boolean value indicating whether the container is visible.
    ///
    /// Returns `true` if controller's view is loaded and is not hidden.
    public var isVisible: Bool {
        viewIfLoaded.map { $0.window != nil && !$0.isHidden } ?? false
    }

    @available(iOS 13.0, tvOS 13.0, *)
    public var windowScene: UIWindowScene? {
        window?.windowScene
    }
}
#endif
