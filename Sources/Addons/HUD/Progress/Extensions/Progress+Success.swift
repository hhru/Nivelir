#if canImport(UIKit)
import Foundation

extension Progress {

    public static func success(
        _ indicator: ProgressSuccessIndicator,
        animation: ProgressAnimation? = .default
    ) -> Self {
        Self.indicator(
            indicator,
            animation: animation
        )
    }

    public static func success(
        _ indicator: ProgressSuccessIndicator,
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
