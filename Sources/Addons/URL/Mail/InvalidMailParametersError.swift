#if os(iOS) || os(tvOS)
import Foundation

public struct InvalidMailParametersError: ScreenError {

    public let description: String

    public init(for trigger: Any) {
        description = """
        Invalid mail parameters for:
          \(trigger)
        """
    }
}

extension Result where Failure == Error {

    internal static func invalidMailParameters(for trigger: Any) -> Self {
        .failure(InvalidMailParametersError(for: trigger))
    }
}
#endif
