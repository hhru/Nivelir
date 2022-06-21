#if canImport(UIKit)
import Foundation

extension HUD {

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
