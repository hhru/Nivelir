#if os(iOS)
import Foundation

public struct InvalidSafariURLError: ScreenError {

    public let description: String

    public init(for trigger: Any) {
        description = """
        Safari does not support the url scheme of:
          \(trigger)
        """
    }
}

extension Result where Failure == Error {

    internal static func invalidSafariURL(for trigger: Any) -> Self {
        .failure(InvalidSafariURLError(for: trigger))
    }
}
#endif
