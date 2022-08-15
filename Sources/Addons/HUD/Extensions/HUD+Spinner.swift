#if canImport(UIKit)
import Foundation

extension HUD {

    /// Creates a HUD representation showing that the task is in progress with the spinner.
    /// - Parameters:
    ///   - indicator: The properties of a ``ProgressSpinnerIndicatorView`` instance.
    ///   - animation: The type of animation to show the ``ProgressView``.
    ///   Can be `nil` to show without animation.
    ///   - style: The style that will be applied to the appearance of the HUD.
    /// - Returns: New instance of HUD with progress that displays ``ProgressSpinnerIndicatorView``.
    public static func spinner(
        _ indicator: ProgressSpinnerIndicator,
        animation: ProgressAnimation? = .default,
        style: HUDStyle = .default
    ) -> Self {
        Self(
            progress: .spinner(
                indicator,
                animation: animation
            ),
            style: style
        )
    }

    /// Creates a HUD representation showing that the task is in progress with the spinner
    /// and message from below.
    /// - Parameters:
    ///   - indicator: The properties of a ``ProgressSpinnerIndicatorView`` instance.
    ///   - message: The properties of a ``ProgressMessageFooterView`` instance.
    ///   - animation: The type of animation to show the ``ProgressView``.
    ///   Can be `nil` to show without animation.
    ///   - style: The style that will be applied to the appearance of the HUD.
    /// - Returns: New instance of HUD with progress that displays ``ProgressSpinnerIndicatorView`` in the center
    /// and ``ProgressMessageFooterView`` in the footer.
    public static func spinner(
        _ indicator: ProgressSpinnerIndicator,
        message: ProgressMessageFooter,
        animation: ProgressAnimation? = .default,
        style: HUDStyle = .default
    ) -> Self {
        Self(
            progress: .spinner(
                indicator,
                message: message,
                animation: animation
            ),
            style: style
        )
    }
}
#endif
