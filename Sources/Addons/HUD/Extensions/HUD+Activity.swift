#if canImport(UIKit)
import Foundation

extension HUD {

    /// Creates a HUD representation showing that the task is in progress with an activity indicator.
    /// - Parameters:
    ///   - indicator: The properties of a ``ProgressActivityIndicatorView`` instance.
    ///   - animation: The type of animation to show the ``ProgressView``.
    ///   Can be `nil` to show without animation.
    ///   - style: The style that will be applied to the appearance of the HUD.
    /// - Returns: New instance of HUD with progress that displays ``ProgressActivityIndicatorView``.
    public static func activity(
        _ indicator: ProgressActivityIndicator,
        animation: ProgressAnimation? = .default,
        style: HUDStyle = .default
    ) -> Self {
        Self(
            progress: .activity(
                indicator,
                animation: animation
            ),
            style: style
        )
    }

    /// Creates a HUD representation showing that the task is in progress with an activity indicator
    /// and a message from below.
    /// - Parameters:
    ///   - indicator: The properties of a ``ProgressActivityIndicatorView`` instance.
    ///   - message: The properties of a ``ProgressMessageFooterView`` instance.
    ///   - animation: The type of animation to show the ``ProgressView``.
    ///   Can be `nil` to show without animation.
    ///   - style: The style that will be applied to the appearance of the HUD.
    /// - Returns: New instance of HUD with progress that displays ``ProgressActivityIndicatorView`` in the center
    /// and ``ProgressMessageFooterView`` in the footer.
    public static func activity(
        _ indicator: ProgressActivityIndicator,
        message: ProgressMessageFooter,
        animation: ProgressAnimation? = .default,
        style: HUDStyle = .default
    ) -> Self {
        Self(
            progress: .activity(
                indicator,
                message: message,
                animation: animation
            ),
            style: style
        )
    }
}
#endif
