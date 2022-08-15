#if canImport(UIKit)
import Foundation

extension HUD {

    /// Creates a HUD representation showing the progress of the task in percent with an animated circle filling.
    /// - Parameters:
    ///   - indicator: The properties of a ``ProgressPercentageIndicatorView`` instance.
    ///   - animation: The type of animation to show the ``ProgressView``.
    ///   Can be `nil` to show without animation.
    ///   - style: The style that will be applied to the appearance of the HUD.
    /// - Returns: New instance of HUD with progress that displays ``ProgressPercentageIndicatorView``.
    public static func percentage(
        _ indicator: ProgressPercentageIndicator,
        animation: ProgressAnimation? = .default,
        style: HUDStyle = .default
    ) -> Self {
        Self(
            progress: .percentage(
                indicator,
                animation: animation
            ),
            style: style
        )
    }

    /// Creates a HUD representation showing the progress of the task in percent with an animated circle filling
    /// and message from below.
    /// - Parameters:
    ///   - indicator: The properties of a ``ProgressPercentageIndicatorView`` instance.
    ///   - message: The properties of a ``ProgressMessageFooterView`` instance.
    ///   - animation: The type of animation to show the ``ProgressView``.
    ///   Can be `nil` to show without animation.
    ///   - style: The style that will be applied to the appearance of the HUD.
    /// - Returns: New instance of HUD with progress that displays ``ProgressPercentageIndicatorView`` in the center
    /// and ``ProgressMessageFooterView`` in the footer.
    public static func percentage(
        _ indicator: ProgressPercentageIndicator,
        message: ProgressMessageFooter,
        animation: ProgressAnimation? = .default,
        style: HUDStyle = .default
    ) -> Self {
        Self(
            progress: .percentage(
                indicator,
                message: message,
                animation: animation
            ),
            style: style
        )
    }
}
#endif
