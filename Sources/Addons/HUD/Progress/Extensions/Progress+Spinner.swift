#if canImport(UIKit)
import Foundation

extension Progress {

    public static func spinner(
        _ indicator: ProgressSpinnerIndicator,
        animation: ProgressAnimation? = .default
    ) -> Self {
        Self.indicator(
            indicator,
            animation: animation
        )
    }

    public static func spinner(
        _ indicator: ProgressSpinnerIndicator,
        message: ProgressMessageFooter,
        animation: ProgressAnimation? = .default
    ) -> Self {
        Self.indicator(
            indicator,
            message: message,
            animation: animation
        )
    }
}
#endif
