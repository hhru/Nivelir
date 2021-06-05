#if canImport(UIKit)
import UIKit

extension UIWindow: ScreenVisibleContainer {

    public var isVisible: Bool {
        !isHidden
    }
}
#endif
