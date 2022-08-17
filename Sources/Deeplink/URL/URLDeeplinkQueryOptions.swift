import Foundation

/// Options for decoding ``URLDeeplink/URLQuery`` implementing the `Decodable` protocol.
///
/// The options include different strategies for decoding the query of the URL.
///
/// - SeeAlso: ``URLDeeplink``
public struct URLDeeplinkQueryOptions {

    /// The strategy used when decoding dates from a part of the query of the URL.
    ///
    /// The default strategy is the ``URLQueryDateDecodingStrategy/deferredToDate`` strategy.
    public let dateDecodingStrategy: URLQueryDateDecodingStrategy

    /// The strategy that a decoder uses to decode raw data.
    ///
    /// The default strategy is the ``URLQueryDataDecodingStrategy/base64`` strategy.
    public let dataDecodingStrategy: URLQueryDataDecodingStrategy

    /// The strategy used by a decoder when it encounters exceptional floating-point values.
    ///
    /// The default strategy is the ``URLQueryNonConformingFloatDecodingStrategy/throw`` strategy.
    public let nonConformingFloatDecodingStrategy: URLQueryNonConformingFloatDecodingStrategy

    /// A value that determines how to decode a type’s coding keys from query keys.
    public let keyDecodingStrategy: URLQueryKeyDecodingStrategy

    /// A dictionary you use to customize the decoding process by providing contextual information.
    public let userInfo: [CodingUserInfoKey: Any]

    /// Creates a new set of options with default formatting settings and decoding strategies.
    /// - Parameters:
    ///   - dateDecodingStrategy: The strategy used when decoding dates from a part of the query of the URL.
    ///   - dataDecodingStrategy: The strategy that a decoder uses to decode raw data.
    ///   - nonConformingFloatDecodingStrategy: The strategy used by a decoder when it
    ///   encounters exceptional floating-point values.
    ///   - keyDecodingStrategy: A value that determines how to decode a type’s coding keys from query keys.
    ///   - userInfo: A dictionary you use to customize the decoding process by providing contextual information.
    public init(
        dateDecodingStrategy: URLQueryDateDecodingStrategy = .deferredToDate,
        dataDecodingStrategy: URLQueryDataDecodingStrategy = .base64,
        nonConformingFloatDecodingStrategy: URLQueryNonConformingFloatDecodingStrategy = .throw,
        keyDecodingStrategy: URLQueryKeyDecodingStrategy = .useDefaultKeys,
        userInfo: [CodingUserInfoKey: Any] = [:]
    ) {
        self.dateDecodingStrategy = dateDecodingStrategy
        self.dataDecodingStrategy = dataDecodingStrategy
        self.nonConformingFloatDecodingStrategy = nonConformingFloatDecodingStrategy
        self.keyDecodingStrategy = keyDecodingStrategy
        self.userInfo = userInfo
    }
}
