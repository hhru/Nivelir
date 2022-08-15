#if canImport(UIKit)
import Foundation

extension HUD {

    /// Creates a HUD representation showing that the task was completed successfully with an animated check mark.
    /// - Parameters:
    ///   - indicator: The properties of a ``ProgressSuccessIndicatorView`` instance.
    ///   - animation: The type of animation to show the ``ProgressView``.
    ///   Can be `nil` to show without animation.
    ///   - style: The style that will be applied to the appearance of the HUD.
    /// - Returns: New instance of HUD with progress that displays ``ProgressSuccessIndicatorView``.
    public static func success(
        _ indicator: ProgressSuccessIndicator,
        animation: ProgressAnimation? = .default,
        style: HUDStyle = .default
    ) -> Self {
        Self(
            progress: .success(
                indicator,
                animation: animation
            ),
            style: style
        )
    }

    /// Creates a HUD representation showing that the task was completed successfully with an animated check mark
    /// and message from below.
    /// - Parameters:
    ///   - indicator: The properties of a ``ProgressSuccessIndicatorView`` instance.
    ///   - message: The properties of a ``ProgressMessageFooterView`` instance.
    ///   - animation: The type of animation to show the ``ProgressView``.
    ///   Can be `nil` to show without animation.
    ///   - style: The style that will be applied to the appearance of the HUD.
    /// - Returns: New instance of HUD with progress that displays ``ProgressSuccessIndicatorView`` in the center
    /// and ``ProgressMessageFooterView`` in the footer.
    public static func success(
        _ indicator: ProgressSuccessIndicator,
        message: ProgressMessageFooter,
        animation: ProgressAnimation? = .default,
        style: HUDStyle = .default
    ) -> Self {
        Self(
            progress: .success(
                indicator,
                message: message,
                animation: animation
            ),
            style: style
        )
    }
}
#endif
