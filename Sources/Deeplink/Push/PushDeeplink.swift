#if canImport(PushKit) && os(iOS)
import Foundation
import PushKit

/// The type of ``Deeplink`` that is handled from the Notification.
///
/// This type allows you to handle the ``Deeplink`` from the notification data, which comes via function parameters.
///
/// Nivelir can decode `dictionaryPayload` depending on the type of ``PushDictionaryPayload``.
/// For example, if ``PushDictionaryPayload`` implements the `Decodable` protocol,
/// then there is no need to manually parse
/// the dictionary of `dictionaryPayload` – check for keys and cast values to the correct type.
/// Instead, the dictionary will be automatically decoded
/// into an instance of the ``PushDictionaryPayload`` type (like with JSON).
/// The options for decoding are set via ``PushDeeplinkDictionaryPayloadOptions``.
///
/// You may need additional context to check and create an instance.
/// For example, it may be a service factory from which additional data can be obtained.
/// The associated type ``PushContext`` is used for this purpose.
public protocol PushDeeplink: Deeplink, AnyPushDeeplink {

    /// The type of contents of the received payload.
    associatedtype PushDictionaryPayload

    /// Type of context for checking and creating a ``Deeplink`` instance.
    associatedtype PushContext

    /// Options for decoding `dictionaryPayload` from push.
    ///
    /// Implement this method if you want to change the data decoding strategies from `dictionaryPayload` notification.
    /// To review the default options, see ``PushDeeplinkDictionaryPayloadOptions``.
    ///
    /// - Parameter context: Additional context for creating ``PushDeeplinkDictionaryPayloadOptions``.
    /// - Returns: Returns new options for decoding `dictionaryPayload` from push.
    static func pushDictionaryPayloadOptions(
        context: PushContext
    ) -> PushDeeplinkDictionaryPayloadOptions

    /// Creating a ``Deeplink`` from data of `PKPushPayload`.
    ///
    /// - Parameters:
    ///   - type: The type value indicating how to interpret the payload.
    ///   - dictionaryPayload: The contents of the received payload.
    ///   - context: Additional context for checking and creating instance.
    /// - Returns: Returns a new instance of ``NotificationDeeplink`` that performs navigation.
    /// Otherwise `nil` if the ``Deeplink`` cannot be handled.
    static func push(
        type: PKPushType,
        dictionaryPayload: PushDictionaryPayload,
        context: PushContext
    ) throws -> Self?
}

// MARK: - Context resolving

extension PushDeeplink where PushContext: Nullable {

    private static func resolveContext(_ context: Any?) throws -> PushContext {
        guard let context else {
            return .none
        }

        guard let pushContent = context as? PushContext else {
            throw DeeplinkInvalidContextError(
                context: context,
                type: PushContext.self,
                for: self
            )
        }

        return pushContent
    }
}

extension PushDeeplink {

    private static func resolveContext(_ context: Any?) throws -> PushContext {
        guard let pushContent = context as? PushContext else {
            throw DeeplinkInvalidContextError(
                context: context,
                type: PushContext.self,
                for: self
            )
        }

        return pushContent
    }
}

// MARK: - Default implementation

extension PushDeeplink {

    /// Options for decoding `dictionaryPayload` from push.
    ///
    /// Implement this method if you want to change the data decoding strategies from `dictionaryPayload` push.
    /// To review the default options, see ``PushDeeplinkDictionaryPayloadOptions``.
    ///
    /// - Parameter context: Additional context for creating ``PushDeeplinkDictionaryPayloadOptions``.
    /// - Returns: Returns new options for decoding `dictionaryPayload` from push.
    public static func pushDictionaryPayloadOptions(
        context: PushContext
    ) -> PushDeeplinkDictionaryPayloadOptions {
        PushDeeplinkDictionaryPayloadOptions()
    }

    /// Options for decoding `dictionaryPayload` from push.
    ///
    /// Implement this method if you want to change the data decoding strategies from `dictionaryPayload` notification.
    /// To review the default options, see ``PushDeeplinkDictionaryPayloadOptions``.
    ///
    /// - Parameter context: Additional context for creating ``PushDeeplinkDictionaryPayloadOptions``.
    /// Must match the context type of ``PushDeeplink/PushContext``.
    ///
    /// - Returns: Returns new options for decoding `userInfo` from notification.
    public static func pushDictionaryPayloadOptions(
        context: Any?
    ) throws -> PushDeeplinkDictionaryPayloadOptions {
        pushDictionaryPayloadOptions(context: try resolveContext(context))
    }
}

extension PushDeeplink where PushDictionaryPayload == Any {

    public static func push(
        payload: PKPushPayload,
        dictionaryPayloadDecoder: PushDictionaryPayload,
        context: PushContext
    ) throws -> AnyPushDeeplink? {
        try push(
            type: payload.type,
            dictionaryPayload: payload.dictionaryPayload,
            context: resolveContext(context)
        )
    }
}

extension PushDeeplink where PushDictionaryPayload == [String: Any] {

    public static func push(
        payload: PKPushPayload,
        dictionaryPayloadDecoder: PushDeeplinkDictionaryPayloadDecoder,
        context: Any?
    ) throws -> AnyPushDeeplink? {
        guard let dictionaryPayload = payload.dictionaryPayload as? [String: Any] else {
            throw PushDeeplinkInvalidDictionaryPayloadError(for: self)
        }

        return try push(
            type: payload.type,
            dictionaryPayload: dictionaryPayload,
            context: resolveContext(context)
        )
    }
}

extension PushDeeplink where PushDictionaryPayload: Decodable {

    public static func push(
        payload: PKPushPayload,
        dictionaryPayloadDecoder: PushDeeplinkDictionaryPayloadDecoder,
        context: Any?
    ) throws -> AnyPushDeeplink? {
        guard let dictionaryPayload = payload.dictionaryPayload as? [String: Any] else {
            throw PushDeeplinkInvalidDictionaryPayloadError(for: self)
        }

        let decodedDictionaryPayload: PushDictionaryPayload

        do {
            decodedDictionaryPayload = try dictionaryPayloadDecoder.decode(
                PushDictionaryPayload.self,
                from: dictionaryPayload
            )
        } catch {
            throw DeeplinkDecodingError(
                underlyingError: error,
                trigger: self
            )
        }

        return try push(
            type: payload.type,
            dictionaryPayload: decodedDictionaryPayload,
            context: resolveContext(context)
        )
    }
}
#endif
