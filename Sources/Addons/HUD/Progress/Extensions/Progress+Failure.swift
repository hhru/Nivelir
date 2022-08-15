#if canImport(UIKit)
import Foundation

extension Progress {

    /// Creates content with failure indicator.
    /// - Parameters:
    ///   - indicator: The properties of a ``ProgressFailureIndicatorView`` instance.
    ///   - animation: The type of animation to show the ``ProgressView``.
    ///   Can be `nil` to show without animation.
    /// - Returns: New instance of ``Progress`` with ``ProgressFailureIndicator``.
    /// Header and footer is empty.
    public static func failure(
        _ indicator: ProgressFailureIndicator,
        animation: ProgressAnimation? = .default
    ) -> Self {
        Self.indicator(
            indicator,
            animation: animation
        )
    }

    /// Creates content with failure indicator and a message from below.
    /// - Parameters:
    ///   - indicator: The properties of a ``ProgressFailureIndicatorView`` instance.
    ///   - message: The properties of a ``ProgressMessageFooterView`` instance.
    ///   - animation: The type of animation to show the ``ProgressView``.
    ///   Can be `nil` to show without animation.
    /// - Returns: New instance of ``Progress`` with ``ProgressFailureIndicatorView`` and ``ProgressMessageFooter``.
    /// Header is empty.
    public static func failure(
        _ indicator: ProgressFailureIndicator,
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
