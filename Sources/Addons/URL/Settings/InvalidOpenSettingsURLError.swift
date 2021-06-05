#if os(iOS) || os(tvOS)
import Foundation

public struct InvalidOpenSettingsURLError: ScreenError {

    public var description: String {
        """
        Invalid settings URL for:
          \(trigger)
        """
    }

    public let trigger: Any

    public init(for trigger: Any) {
        self.trigger = trigger
    }
}

extension Result where Failure == Error {

    internal static func invalidOpenSettingsURL(for trigger: Any) -> Self {
        .failure(InvalidOpenSettingsURLError(for: trigger))
    }
}
#endif
