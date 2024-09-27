#if os(iOS) || os(tvOS)
import Foundation

public struct InvalidOpenSettingsURLError: ScreenError {

    public let description: String

    public init(for trigger: Any) {
        description = """
        Invalid settings URL for:
          \(trigger)
        """
    }
}

extension Result where Failure == Error {

    internal static func invalidOpenSettingsURL(for trigger: Any) -> Self {
        .failure(InvalidOpenSettingsURLError(for: trigger))
    }
}
#endif
