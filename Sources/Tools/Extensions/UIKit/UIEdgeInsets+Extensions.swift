#if canImport(UIKit)
import UIKit

extension UIEdgeInsets {

    internal var horizontal: CGFloat {
        left + right
    }

    internal var vertical: CGFloat {
        top + bottom
    }

    internal init(equilateral side: CGFloat) {
        self.init(top: side, left: side, bottom: side, right: side)
    }
}
#endif
