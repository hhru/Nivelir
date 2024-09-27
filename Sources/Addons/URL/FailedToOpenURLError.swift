#if os(iOS) || os(tvOS)
import Foundation

public struct FailedToOpenURLError: ScreenError {

    public let description: String

    public init(
        url: URL,
        for trigger: Any
    ) {
        description = """
        Failed to open URL ("\(url)") for:
          \(trigger)
        """
    }
}

extension Result where Failure == Error {

    internal static func failedToOpenURL(_ url: URL, for trigger: Any) -> Self {
        .failure(FailedToOpenURLError(url: url, for: trigger))
    }
}
#endif
