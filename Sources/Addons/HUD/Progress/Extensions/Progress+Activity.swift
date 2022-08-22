#if canImport(UIKit)
import Foundation

extension Progress {

    /// Creates content with an activity indicator.
    /// - Parameters:
    ///   - indicator: The properties of a ``ProgressActivityIndicatorView`` instance.
    ///   - animation: The type of animation to show the ``ProgressView``.
    ///   Can be `nil` to show without animation.
    /// - Returns: New instance of ``Progress`` with ``ProgressActivityIndicator``.
    /// Header and footer is empty.
    public static func activity(
        _ indicator: ProgressActivityIndicator,
        animation: ProgressAnimation? = .default
    ) -> Self {
        Self.indicator(
            indicator,
            animation: animation
        )
    }

    /// Creates content with an activity indicator and a message from below.
    /// - Parameters:
    ///   - indicator: The properties of a ``ProgressActivityIndicatorView`` instance.
    ///   - message: The properties of a ``ProgressMessageFooterView`` instance.
    ///   - animation: The type of animation to show the ``ProgressView``.
    ///   Can be `nil` to show without animation.
    /// - Returns: New instance of ``Progress`` with ``ProgressActivityIndicator`` and ``ProgressMessageFooter``.
    /// Header is empty.
    public static func activity(
        _ indicator: ProgressActivityIndicator,
        message: ProgressMessageFooter,
        animation: ProgressAnimation? = .default
    ) -> Self {
        Self.indicator(
            indicator,
            message: message,
            animation: animation
        )
    }
}
#endif
