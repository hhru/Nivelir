#if canImport(UIKit)
import UIKit

extension UIScreen {

    internal var pixelSize: CGFloat {
        1.0 / scale
    }
}
#endif
