#if canImport(UIKit)
import UIKit

/// The type of progress view animation of the ``HUD``.
///
/// An animation is used to update and show the `header`, `indicator` and `footer` parts of the progress view.
@MainActor
public enum ProgressAnimation {

    /// Custom animation for showing progress view of the HUD.
    ///
    /// Implement ``ProgressCustomAnimation`` to configure a custom animation
    /// and pass an instance to the associated value.
    case custom(ProgressCustomAnimation)

    /// Animates updates of parts of the progress view.
    /// - Parameters:
    ///   - view: View of the `header`, `indicator` or `footer` part.
    ///   - previousView: Previous view of the `header`, `indicator` or `footer` part.
    ///   - containerView: Container view of the `header`, `indicator` or `footer` part.
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
