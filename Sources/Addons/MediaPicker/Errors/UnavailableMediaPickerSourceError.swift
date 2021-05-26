#if os(iOS)
import Foundation

public struct UnavailableMediaPickerSourceError: ScreenError {

    public var description: String {
        """
        Media source is not available for:
          \(trigger)
        """
    }

    public let trigger: Any

    public init(for trigger: Any) {
        self.trigger = trigger
    }
}

extension Result where Failure == Error {

    internal static func unavailableMediaPickerSource(for trigger: Any) -> Self {
        .failure(UnavailableMediaPickerSourceError(for: trigger))
    }
}
#endif
