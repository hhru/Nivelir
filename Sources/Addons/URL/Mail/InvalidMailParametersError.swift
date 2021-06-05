#if os(iOS) || os(tvOS)
import Foundation

public struct InvalidMailParametersError: ScreenError {

    public var description: String {
        """
        Invalid mail parameters for:
          \(trigger)
        """
    }

    public let trigger: Any

    public init(for trigger: Any) {
        self.trigger = trigger
    }
}

extension Result where Failure == Error {

    internal static func invalidMailParameters(for trigger: Any) -> Self {
        .failure(InvalidMailParametersError(for: trigger))
    }
}
#endif
