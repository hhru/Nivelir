#if os(iOS)
import Foundation

public struct InvalidCallParametersError: ScreenError {

    public let description: String

    public init(for trigger: Any) {
        description = """
        Invalid call parameters for:
          \(trigger)
        """
    }
}

extension Result where Failure == Error {

    internal static func invalidCallParameters(for trigger: Any) -> Self {
        .failure(InvalidCallParametersError(for: trigger))
    }
}
#endif
