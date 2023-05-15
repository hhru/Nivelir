#if canImport(UIKit)
import UIKit

extension UIView {

    internal var firstResponder: UIView? {
        if isFirstResponder {
            return self
        }

        for subview in subviews {
            if let firstResponder = subview.firstResponder {
                return firstResponder
            }
        }

        return nil
    }
}
#endif
