#if os(iOS) || os(tvOS)
import Foundation

public struct InvalidStoreAppIDError: ScreenError {

    public var description: String {
        """
        Invalid store app ID for:
          \(trigger)
        """
    }

    public let trigger: Any

    public init(for trigger: Any) {
        self.trigger = trigger
    }
}

extension Result where Failure == Error {

    internal static func invalidStoreAppID(for trigger: Any) -> Self {
        .failure(InvalidStoreAppIDError(for: trigger))
    }
}
#endif
