#if canImport(PushKit) && os(iOS)
import Foundation
import PushKit

/// Failed to extract `dictionaryPayload` from payload of the push.
public struct PushDeeplinkInvalidDictionaryPayloadError: DeeplinkError {

    public var description: String {
        """
        Failed to extract dictionaryPayload from payload of the push for:
          \(trigger)
        """
    }

    /// Payload of the push that caused the error.
    public let payload: PKPushPayload

    /// The deeplink that caused the error.
    public let trigger: Any

    /// Creates an error.
    ///
    /// - Parameters:
    ///   - payload: Payload of the push that caused the error.
    ///   - trigger: The deeplink that caused the error.
    public init(
        payload: PKPushPayload,
        for trigger: Any
    ) {
        self.payload = payload
        self.trigger = trigger
    }
}
#endif
