import Foundation

/// Options for decoding ``ShortcutDeeplink/ShortcutUserInfo`` implementing the `Decodable` protocol.
///
/// The options include different strategies for decoding data
/// from app-specific information that provided for use when your app performs the Home screen quick action.
///
/// - SeeAlso: ``ShortcutDeeplink``
public struct ShortcutDeeplinkUserInfoOptions {

    /// The strategy used when decoding dates from a part of the dictionary.
    ///
    /// The default strategy is the ``DictionaryDateDecodingStrategy/deferredToDate`` strategy.
    public let dateDecodingStrategy: DictionaryDateDecodingStrategy

    /// The strategy that a decoder uses to decode raw data.
    ///
    /// The default strategy is the ``DictionaryDataDecodingStrategy/base64`` strategy.
    public let dataDecodingStrategy: DictionaryDataDecodingStrategy

    /// The strategy used by a decoder when it encounters exceptional floating-point values.
    ///
    /// The default strategy is the ``DictionaryNonConformingFloatDecodingStrategy/throw`` strategy.
    public let nonConformingFloatDecodingStrategy: DictionaryNonConformingFloatDecodingStrategy

    /// A value that determines how to decode a type’s coding keys from dictionary keys.
    public let keyDecodingStrategy: DictionaryKeyDecodingStrategy

    /// A dictionary you use to customize the decoding process by providing contextual information.
    public let userInfo: [CodingUserInfoKey: Any]

    /// Creates a new set of options with default formatting settings and decoding strategies.
    /// - Parameters:
    ///   - dateDecodingStrategy: The strategy used when decoding dates from a part of the dictionary.
    ///   - dataDecodingStrategy: The strategy that a decoder uses to decode raw data.
    ///   - nonConformingFloatDecodingStrategy: The strategy used by a decoder when it
    ///   encounters exceptional floating-point values.
    ///   - keyDecodingStrategy: A value that determines how to decode a type’s coding keys from dictionary keys.
    ///   - userInfo: A dictionary you use to customize the decoding process by providing contextual information.
    public init(
        dateDecodingStrategy: DictionaryDateDecodingStrategy = .deferredToDate,
        dataDecodingStrategy: DictionaryDataDecodingStrategy = .base64,
        nonConformingFloatDecodingStrategy: DictionaryNonConformingFloatDecodingStrategy = .throw,
        keyDecodingStrategy: DictionaryKeyDecodingStrategy = .useDefaultKeys,
        userInfo: [CodingUserInfoKey: Any] = [:]
    ) {
        self.dateDecodingStrategy = dateDecodingStrategy
        self.dataDecodingStrategy = dataDecodingStrategy
        self.nonConformingFloatDecodingStrategy = nonConformingFloatDecodingStrategy
        self.keyDecodingStrategy = keyDecodingStrategy
        self.userInfo = userInfo
    }
}
