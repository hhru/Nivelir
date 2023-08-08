#if os(iOS)
import Foundation

/// A type that decodes instances of a data type from the dictionary.
///
/// The example below shows how to decode an instance of a simple GroceryProduct type from the dictionary.
/// The type adopts Codable so that it’s decodable using a instance of ``PushDeeplinkDictionaryPayloadDecoder``.
///
/// ```swift
/// struct GroceryProduct: Codable {
///     var name: String
///     var points: Int
///     var description: String?
/// }
///
/// let dictionary: [String: Any] = [
///     "name": "Durian",
///     "points": 600,
///     "description": "A fruit with a distinctive scent."
/// ]
///
/// let decoder: PushDeeplinkDictionaryPayloadDecoder
/// let product = try decoder.decode(GroceryProduct.self, from: dictionary)
///
/// print(product.name) // Prints "Durian"
/// ```
///
/// - SeeAlso: ``PushDeeplink``
/// - SeeAlso: ``PushDeeplinkDictionaryPayloadOptions``
public protocol PushDeeplinkDictionaryPayloadDecoder {

    /// Returns a value of the type you specify, decoded from a dictionary.
    ///
    /// If a value within the dictionary fails to decode, this method throws the corresponding error.
    /// - Parameters:
    ///   - type: The type of the value to decode from the supplied dictionary.
    ///   - dictionary: The dictionary to decode.
    /// - Returns: A value of the specified type, if the decoder can parse the data.
    func decode<T: Decodable>(_ type: T.Type, from dictionary: [String: Any]) throws -> T
}

extension DictionaryDecoder: PushDeeplinkDictionaryPayloadDecoder { }
#endif
