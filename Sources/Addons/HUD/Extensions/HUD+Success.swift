#if canImport(UIKit)
import Foundation

extension HUD {

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
