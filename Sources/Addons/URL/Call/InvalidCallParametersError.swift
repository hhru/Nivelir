#if os(iOS)
import Foundation

public struct InvalidCallParametersError: ScreenError {

    public var description: String {
        """
        Invalid call parameters for:
          \(trigger)
        """
    }

    public let trigger: Any

    public init(for trigger: Any) {
        self.trigger = trigger
    }
}

extension Result where Failure == Error {

    internal static func invalidCallParameters(for trigger: Any) -> Self {
        .failure(InvalidCallParametersError(for: trigger))
    }
}
#endif
