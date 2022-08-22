#if canImport(UIKit)
import Foundation

extension Progress {

    /// Creates content with spinner indicator.
    /// - Parameters:
    ///   - indicator: The properties of a ``ProgressSpinnerIndicatorView`` instance.
    ///   - animation: The type of animation to show the ``ProgressView``.
    ///   Can be `nil` to show without animation.
    /// - Returns: New instance of ``Progress`` with ``ProgressSpinnerIndicator``.
    /// Header and footer is empty.
    public static func spinner(
        _ indicator: ProgressSpinnerIndicator,
        animation: ProgressAnimation? = .default
    ) -> Self {
        Self.indicator(
            indicator,
            animation: animation
        )
    }

    /// Creates content with spinner indicator and a message from below.
    /// - Parameters:
    ///   - indicator: The properties of a ``ProgressSpinnerIndicatorView`` instance.
    ///   - message: The properties of a ``ProgressMessageFooterView`` instance.
    ///   - animation: The type of animation to show the ``ProgressView``.
    ///   Can be `nil` to show without animation.
    /// - Returns: New instance of ``Progress`` with ``ProgressSpinnerIndicator`` and ``ProgressMessageFooter``.
    /// Header is empty.
    public static func spinner(
        _ indicator: ProgressSpinnerIndicator,
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
