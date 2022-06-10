#if os(iOS)
import Foundation

public struct InvalidSafariURLError: ScreenError {

    public var description: String {
        """
        Safari does not support the url scheme of:
          \(trigger)
        """
    }

    public let trigger: Any

    public init(for trigger: Any) {
        self.trigger = trigger
    }
}

extension Result where Failure == Error {

    internal static func invalidSafariURL(for trigger: Any) -> Self {
        .failure(InvalidSafariURLError(for: trigger))
    }
}
#endif
