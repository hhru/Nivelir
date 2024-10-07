#if os(iOS)
import Foundation

public struct UnavailableMediaPickerTypesError: ScreenError {

    public let description: String

    public init(for trigger: Any) {
        description = """
        Media types are not available for:
          \(trigger)
        """
    }
}

extension Result where Failure == Error {

    internal static func unavailableMediaPickerTypes(for trigger: Any) -> Self {
        .failure(UnavailableMediaPickerTypesError(for: trigger))
    }
}
#endif
