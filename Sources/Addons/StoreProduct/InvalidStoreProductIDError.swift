#if os(iOS)
import Foundation

public struct InvalidStoreProductIDError: ScreenError {

    public let description: String

    public init(for trigger: Any) {
        description = """
        Invalid store product ID for:
          \(trigger)
        """
    }
}

extension Result where Failure == Error {

    internal static func invalidStoreProductID(for trigger: Any) -> Self {
        .failure(InvalidStoreProductIDError(for: trigger))
    }
}
#endif
