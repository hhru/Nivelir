import Foundation

public struct MediaPickerSourceAccessDeniedError: ScreenError {

    public var description: String {
        """
        User does not allow the app to access the media source for:
          \(trigger)
        """
    }

    public let trigger: Any

    public init(for trigger: Any) {
        self.trigger = trigger
    }
}

extension Result where Failure == Error {

    internal static func mediaPickerSourceAccessDenied(for trigger: Any) -> Self {
        .failure(MediaPickerSourceAccessDeniedError(for: trigger))
    }
}
