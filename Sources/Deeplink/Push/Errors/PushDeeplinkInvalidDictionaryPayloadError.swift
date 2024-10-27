#if canImport(PushKit) && os(iOS)
import Foundation
import PushKit

/// Failed to extract `dictionaryPayload` from payload of the push.
public struct PushDeeplinkInvalidDictionaryPayloadError: DeeplinkError {

    public let description: String

    /// Creates an error.
    ///
    /// - Parameters:
    ///   - payload: Payload of the push that caused the error.
    ///   - trigger: The deeplink that caused the error.
    public init(
        for trigger: Any
    ) {
        description = """
        Failed to extract dictionaryPayload from response of the push for:
          \(trigger)
        """
    }
}
#endif
