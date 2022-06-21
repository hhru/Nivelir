#if canImport(UIKit)
import Foundation

extension HUD {

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
