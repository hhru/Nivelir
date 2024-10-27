#if os(iOS) || os(tvOS)
import Foundation

public struct InvalidStoreAppIDError: ScreenError {

    public let description: String

    public init(for trigger: Any) {
        description = """
        Invalid store app ID for:
          \(trigger)
        """
    }
}

extension Result where Failure == Error {

    internal static func invalidStoreAppID(for trigger: Any) -> Self {
        .failure(InvalidStoreAppIDError(for: trigger))
    }
}
#endif
