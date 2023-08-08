#if canImport(PushKit) && os(iOS)
import Foundation
import PushKit

/// Erased type of ``PushDeeplink`` protocol.
///
/// - SeeAlso: ``PushDeeplink``
/// - SeeAlso: ``DeeplinkManager``
public protocol AnyPushDeeplink: AnyDeeplink {

    /// Options for decoding `dictionaryPayload` from push.
    ///
    /// Implement this method if you want to change the data decoding strategies from `dictionaryPayload` of push.
    /// To review the default options, see ``PushDeeplinkDictionaryPayloadOptions``.
    ///
    /// - Parameter context: Additional context for creating ``PushDeeplinkDictionaryPayloadOptions``.
    /// Must match the context type of ``PushDeeplink/PushContext``.
    ///
    /// - Returns: Returns new options for decoding `dictionaryPayload` from push.
    static func pushDictionaryPayloadOptions(
        context: Any?
    ) throws -> PushDeeplinkDictionaryPayloadOptions

    /// Creating a ``Deeplink`` from a notification.
    ///
    /// - Parameters:
    ///   - payload: An object that contains information about a received PushKit notification.
    ///   - dictionaryPayloadDecoder: Decoder for decoding dictionary from `dictionaryPayload`.
    ///   - context: Additional context for checking and creating ``PushDeeplink``.
    ///   Must match the context type of ``PushDeeplink/PushContext``.
    /// - Returns: Returns a new instance of ``PushDeeplink`` that performs navigation from `payload` data.
    /// Otherwise `nil` if the ``Deeplink`` from `payload` cannot be handled.
    static func push(
        payload: PKPushPayload,
        dictionaryPayloadDecoder: PushDeeplinkDictionaryPayloadDecoder,
        context: Any?
    ) throws -> AnyPushDeeplink?
}
#endif
