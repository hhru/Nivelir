#if canImport(UIKit)
import UIKit

extension UIViewController: ScreenContainer {

    public var isVisible: Bool {
        viewIfLoaded.map { $0.window != nil && !$0.isHidden } ?? false
    }
}
#endif
