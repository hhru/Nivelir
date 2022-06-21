#if canImport(UIKit)
import Foundation

extension HUD {

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
