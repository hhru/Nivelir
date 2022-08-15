#if canImport(UIKit)
import Foundation

extension Progress {

    /// Creates content with percentage indicator.
    /// - Parameters:
    ///   - indicator: The properties of a ``ProgressPercentageIndicatorView`` instance.
    ///   - animation: The type of animation to show the ``ProgressView``.
    ///   Can be `nil` to show without animation.
    /// - Returns: New instance of ``Progress`` with ``ProgressPercentageIndicator``.
    /// Header and footer is empty.
    public static func percentage(
        _ indicator: ProgressPercentageIndicator,
        animation: ProgressAnimation? = .default
    ) -> Self {
        Self.indicator(
            indicator,
            animation: animation
        )
    }

    /// Creates content with percentage indicator and a message from below.
    /// - Parameters:
    ///   - indicator: The properties of a ``ProgressPercentageIndicatorView`` instance.
    ///   - message: The properties of a ``ProgressMessageFooterView`` instance.
    ///   - animation: The type of animation to show the ``ProgressView``.
    ///   Can be `nil` to show without animation.
    /// - Returns: New instance of ``Progress`` with ``ProgressPercentageIndicator`` and ``ProgressMessageFooter``.
    /// Header is empty.
    public static func percentage(
        _ indicator: ProgressPercentageIndicator,
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
