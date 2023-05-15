#if canImport(UIKit)
import UIKit

extension UIScrollView {

    internal var isScrolledVertically: Bool {
        contentOffset.y >= -adjustedContentInset.top + UIScreen.main.pixelSize
    }

    internal var canScrollVertically: Bool {
        if alwaysBounceVertical {
            return true
        }

        return contentSize.height >= frame.height
            - adjustedContentInset.vertical
            + UIScreen.main.pixelSize
    }

    internal var canScrollHorizontally: Bool {
        if alwaysBounceHorizontal {
            return true
        }

        return contentSize.width >= frame.width
            - adjustedContentInset.horizontal
            + UIScreen.main.pixelSize
    }

    internal func resetVerticalScroll(finishing: Bool) {
        setContentOffset(
            CGPoint(
                x: contentOffset.x,
                y: -adjustedContentInset.top
            ),
            animated: false
        )

        if finishing, panGestureRecognizer.isEnabled {
            panGestureRecognizer.isEnabled = false
            panGestureRecognizer.isEnabled = true
        }
    }
}
#endif
