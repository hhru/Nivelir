#if canImport(UIKit)
import UIKit

extension UIViewController: ScreenVisibleContainer {

    public var isVisible: Bool {
        viewIfLoaded.map { $0.window != nil && !$0.isHidden } ?? false
    }

    @available(iOS 13.0, tvOS 13.0, *)
    public var windowScene: UIWindowScene? {
        viewIfLoaded?.window?.windowScene
    }
}
#endif
