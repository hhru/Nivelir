#if canImport(UIKit)
import Foundation

extension HUD {

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
