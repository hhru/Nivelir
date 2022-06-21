#if canImport(UIKit)
import UIKit

public protocol ProgressCustomAnimation {

    func animateView(
        _ view: UIView,
        previousView: UIView,
        containerView: UIView
    )
}
#endif
