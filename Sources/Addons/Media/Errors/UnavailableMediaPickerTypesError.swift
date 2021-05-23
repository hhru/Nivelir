import Foundation

public struct UnavailableMediaPickerTypesError: ScreenError {

    public var description: String {
        """
        Media types are not available for:
          \(trigger)
        """
    }

    public let trigger: Any

    public init(for trigger: Any) {
        self.trigger = trigger
    }
}

extension Result where Failure == Error {

    internal static func unavailableMediaPickerTypes(for trigger: Any) -> Self {
        .failure(UnavailableMediaPickerTypesError(for: trigger))
    }
}
