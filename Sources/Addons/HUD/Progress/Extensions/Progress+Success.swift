#if canImport(UIKit)
import Foundation

extension Progress {

    /// Creates content with success indicator.
    /// - Parameters:
    ///   - indicator: The properties of a ``ProgressSuccessIndicatorView`` instance.
    ///   - animation: The type of animation to show the ``ProgressView``.
    ///   Can be `nil` to show without animation.
    /// - Returns: New instance of ``Progress`` with ``ProgressSuccessIndicator``.
    /// Header and footer is empty.
    public static func success(
        _ indicator: ProgressSuccessIndicator,
        animation: ProgressAnimation? = .default
    ) -> Self {
        Self.indicator(
            indicator,
            animation: animation
        )
    }

    /// Creates content with success indicator and a message from below.
    /// - Parameters:
    ///   - indicator: The properties of a ``ProgressSuccessIndicatorView`` instance.
    ///   - message: The properties of a ``ProgressMessageFooterView`` instance.
    ///   - animation: The type of animation to show the ``ProgressView``.
    ///   Can be `nil` to show without animation.
    /// - Returns: New instance of ``Progress`` with ``ProgressSuccessIndicator`` and ``ProgressMessageFooter``.
    /// Header is empty.
    public static func success(
        _ indicator: ProgressSuccessIndicator,
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
