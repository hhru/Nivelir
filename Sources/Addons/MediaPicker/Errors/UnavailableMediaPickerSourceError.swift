#if os(iOS)
import Foundation

public struct UnavailableMediaPickerSourceError: ScreenError {

    public let description: String

    public init(for trigger: Any) {
        description = """
        Media source is not available for:
          \(trigger)
        """
    }
}

extension Result where Failure == Error {

    internal static func unavailableMediaPickerSource(for trigger: Any) -> Self {
        .failure(UnavailableMediaPickerSourceError(for: trigger))
    }
}
#endif
