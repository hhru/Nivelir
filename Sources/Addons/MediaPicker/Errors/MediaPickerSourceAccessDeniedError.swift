#if os(iOS)
import Foundation

public struct MediaPickerSourceAccessDeniedError: ScreenError {

    public let description: String

    public init(for trigger: Any) {
        description = """
        User does not allow the app to access the media source for:
          \(trigger)
        """
    }
}

extension Result where Failure == Error {

    internal static func mediaPickerSourceAccessDenied(for trigger: Any) -> Self {
        .failure(MediaPickerSourceAccessDeniedError(for: trigger))
    }
}
#endif
