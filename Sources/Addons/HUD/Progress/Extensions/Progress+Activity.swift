#if canImport(UIKit)
import Foundation

extension Progress {

    public static func activity(
        _ indicator: ProgressActivityIndicator,
        animation: ProgressAnimation? = .default
    ) -> Self {
        Self.indicator(
            indicator,
            animation: animation
        )
    }

    public static func activity(
        _ indicator: ProgressActivityIndicator,
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
