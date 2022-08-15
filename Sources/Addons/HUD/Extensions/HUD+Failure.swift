#if canImport(UIKit)
import Foundation

extension HUD {

    /// Creates a HUD representation showing that the task ended with an error with an animated cross.
    /// - Parameters:
    ///   - indicator: The properties of a ``ProgressFailureIndicatorView`` instance.
    ///   - animation: The type of animation to show the ``ProgressView``.
    ///   Can be `nil` to show without animation.
    ///   - style: The style that will be applied to the appearance of the HUD.
    /// - Returns: New instance of HUD with progress that displays ``ProgressFailureIndicatorView``.
    public static func failure(
        _ indicator: ProgressFailureIndicator,
        animation: ProgressAnimation? = .default,
        style: HUDStyle = .default
    ) -> Self {
        Self(
            progress: .failure(
                indicator,
                animation: animation
            ),
            style: style
        )
    }

    /// Creates a HUD representation showing that the task ended with an error with an animated cross
    /// and a message from below.
    /// - Parameters:
    ///   - indicator: The properties of a ``ProgressFailureIndicatorView`` instance.
    ///   - message: The properties of a ``ProgressMessageFooterView`` instance.
    ///   - animation: The type of animation to show the ``ProgressView``.
    ///   Can be `nil` to show without animation.
    ///   - style: The style that will be applied to the appearance of the HUD.
    /// - Returns: New instance of HUD with progress that displays ``ProgressFailureIndicatorView`` in the center
    /// and ``ProgressMessageFooterView`` in the footer.
    public static func failure(
        _ indicator: ProgressFailureIndicator,
        message: ProgressMessageFooter,
        animation: ProgressAnimation? = .default,
        style: HUDStyle = .default
    ) -> Self {
        Self(
            progress: .failure(
                indicator,
                message: message,
                animation: animation
            ),
            style: style
        )
    }
}
#endif
