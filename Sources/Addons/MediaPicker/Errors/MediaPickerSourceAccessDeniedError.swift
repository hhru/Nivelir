#if os(iOS)
import Foundation

public struct MediaPickerSourceAccessDeniedError: ScreenError {

    public let description: String
    public let isRequested: Bool

    public init(
        for trigger: Any,
        isRequested: Bool = false
    ) {
        description = """
        User does not allow the app to access the media source for:
          \(trigger)
        """

        self.isRequested = isRequested
    }
}

extension Result where Failure == Error {

    internal static func mediaPickerSourceAccessDenied(
        for trigger: Any,
        isRequested: Bool = false
    ) -> Self {
        .failure(
            MediaPickerSourceAccessDeniedError(
                for: trigger,
                isRequested: isRequested
            )
        )
    }
}
#endif
