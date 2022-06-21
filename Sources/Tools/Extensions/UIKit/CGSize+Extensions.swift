#if canImport(UIKit)
import UIKit

extension CGSize {

    internal init(equilateral side: CGFloat) {
        self.init(width: side, height: side)
    }

    internal func outset(by insets: UIEdgeInsets) -> Self {
        Self(
            width: width + insets.horizontal,
            height: height + insets.vertical
        )
    }
}
#endif
