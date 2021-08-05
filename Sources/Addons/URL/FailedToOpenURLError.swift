#if os(iOS) || os(tvOS)
import Foundation

public struct FailedToOpenURLError: ScreenError {

    public var description: String {
        """
        Failed to open URL for:
          \(trigger)
        """
    }

    public let trigger: Any

    public init(for trigger: Any) {
        self.trigger = trigger
    }
}

extension Result where Failure == Error {

    internal static func failedToOpenURL(for trigger: Any) -> Self {
        .failure(FailedToOpenURLError(for: trigger))
    }
}
#endif
