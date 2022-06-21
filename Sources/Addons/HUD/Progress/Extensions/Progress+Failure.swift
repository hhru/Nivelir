#if canImport(UIKit)
import Foundation

extension Progress {

    public static func failure(
        _ indicator: ProgressFailureIndicator,
        animation: ProgressAnimation? = .default
    ) -> Self {
        Self.indicator(
            indicator,
            animation: animation
        )
    }

    public static func failure(
        _ indicator: ProgressFailureIndicator,
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
