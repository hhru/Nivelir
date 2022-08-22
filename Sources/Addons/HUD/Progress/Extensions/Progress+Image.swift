#if canImport(UIKit)
import Foundation

extension Progress {

    /// Creates content with image indicator.
    /// - Parameters:
    ///   - indicator: The properties of a ``ProgressImageIndicatorView`` instance.
    ///   - animation: The type of animation to show the ``ProgressView``.
    ///   Can be `nil` to show without animation.
    /// - Returns: New instance of ``Progress`` with ``ProgressImageIndicator``.
    /// Header and footer is empty.
    public static func image(
        _ indicator: ProgressImageIndicator,
        animation: ProgressAnimation? = .default
    ) -> Self {
        Self.indicator(
            indicator,
            animation: animation
        )
    }

    /// Creates content with image indicator and a message from below.
    /// - Parameters:
    ///   - indicator: The properties of a ``ProgressImageIndicatorView`` instance.
    ///   - message: The properties of a ``ProgressMessageFooterView`` instance.
    ///   - animation: The type of animation to show the ``ProgressView``.
    ///   Can be `nil` to show without animation.
    /// - Returns: New instance of ``Progress`` with ``ProgressImageIndicator`` and ``ProgressMessageFooter``.
    /// Header is empty.
    public static func image(
        _ indicator: ProgressImageIndicator,
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
