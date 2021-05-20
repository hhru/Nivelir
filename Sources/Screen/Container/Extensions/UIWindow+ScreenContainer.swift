#if canImport(UIKit)
import UIKit

extension UIWindow: ScreenContainer {

    public var isVisible: Bool {
        !isHidden
    }
}
#endif
