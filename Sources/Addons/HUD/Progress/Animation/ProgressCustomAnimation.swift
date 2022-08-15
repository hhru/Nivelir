#if canImport(UIKit)
import UIKit

/// A type describing the animation of updating progress view of``HUD``.
///
/// See ``ProgressDefaultAnimation`` for example.
public protocol ProgressCustomAnimation {

    /// Animates updates of parts of the progress view.
    /// - Parameters:
    ///   - view: View of the `header`, `indicator` or `footer` part.
    ///   - previousView: Previous view of the `header`, `indicator` or `footer` part.
    ///   - containerView: Container view of the `header`, `indicator` or `footer` part.
    func animateView(
        _ view: UIView,
        previousView: UIView,
        containerView: UIView
    )
}
#endif
