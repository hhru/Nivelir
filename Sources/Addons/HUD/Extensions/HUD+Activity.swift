#if canImport(UIKit)
import Foundation

extension HUD {

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
