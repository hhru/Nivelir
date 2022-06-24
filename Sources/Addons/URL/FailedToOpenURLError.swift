#if os(iOS) || os(tvOS)
import Foundation

public struct FailedToOpenURLError: ScreenError {

    public var description: String {
        """
        Failed to open URL ("\(url)") for:
          \(trigger)
        """
    }

    public let url: URL
    public let trigger: Any

    public init(
        url: URL,
        for trigger: Any
    ) {
        self.url = url
        self.trigger = trigger
    }
}

extension Result where Failure == Error {

    internal static func failedToOpenURL(_ url: URL, for trigger: Any) -> Self {
        .failure(FailedToOpenURLError(url: url, for: trigger))
    }
}
#endif
