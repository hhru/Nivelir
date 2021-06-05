#if os(iOS)
import Foundation

public struct InvalidStoreProductIDError: ScreenError {

    public var description: String {
        """
        Invalid store product ID for:
          \(trigger)
        """
    }

    public let trigger: Any

    public init(for trigger: Any) {
        self.trigger = trigger
    }
}

extension Result where Failure == Error {

    internal static func invalidStoreProductID(for trigger: Any) -> Self {
        .failure(InvalidStoreProductIDError(for: trigger))
    }
}
#endif
