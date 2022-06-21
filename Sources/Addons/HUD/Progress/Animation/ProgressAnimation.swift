#if canImport(UIKit)
import UIKit

public enum ProgressAnimation {

    case custom(ProgressCustomAnimation)

    public func animateView(
        _ view: UIView,
        previousView: UIView,
        containerView: UIView
    ) {
        switch self {
        case let .custom(animation):
            animation.animateView(
                view,
                previousView: previousView,
                containerView: containerView
            )
        }
    }
}
#endif
