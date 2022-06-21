#if canImport(UIKit)
import Foundation

extension Progress {

    public static func percentage(
        _ indicator: ProgressPercentageIndicator,
        animation: ProgressAnimation? = .default
    ) -> Self {
        Self.indicator(
            indicator,
            animation: animation
        )
    }

    public static func percentage(
        _ indicator: ProgressPercentageIndicator,
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
