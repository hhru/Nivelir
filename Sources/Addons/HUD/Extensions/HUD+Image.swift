#if canImport(UIKit)
import Foundation

extension HUD {

    /// Creates a HUD representation showing the image.
    /// - Parameters:
    ///   - indicator: The properties of a ``ProgressImageIndicatorView`` instance.
    ///   - animation: The type of animation to show the ``ProgressView``.
    ///   Can be `nil` to show without animation.
    ///   - style: The style that will be applied to the appearance of the HUD.
    /// - Returns: New instance of HUD with progress that displays ``ProgressImageIndicatorView``.
    public static func image(
        _ indicator: ProgressImageIndicator,
        animation: ProgressAnimation? = .default,
        style: HUDStyle = .default
    ) -> Self {
        Self(
            progress: .image(
                indicator,
                animation: animation
            ),
            style: style
        )
    }

    /// Creates a HUD representation showing the image and message from below.
    /// - Parameters:
    ///   - indicator: The properties of a ``ProgressImageIndicatorView`` instance.
    ///   - message: The properties of a ``ProgressMessageFooterView`` instance.
    ///   - animation: The type of animation to show the ``ProgressView``.
    ///   Can be `nil` to show without animation.
    ///   - style: The style that will be applied to the appearance of the HUD.
    /// - Returns: New instance of HUD with progress that displays ``ProgressImageIndicatorView`` in the center
    /// and ``ProgressMessageFooterView`` in the footer.
    public static func image(
        _ indicator: ProgressImageIndicator,
        message: ProgressMessageFooter,
        animation: ProgressAnimation? = .default,
        style: HUDStyle = .default
    ) -> Self {
        Self(
            progress: .image(
                indicator,
                message: message,
                animation: animation
            ),
            style: style
        )
    }
}
#endif
