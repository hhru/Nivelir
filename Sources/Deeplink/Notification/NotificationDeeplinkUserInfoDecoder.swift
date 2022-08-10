#if os(iOS)
import Foundation

/// A type that decodes instances of a data type from the dictionary.
///
/// The example below shows how to decode an instance of a simple GroceryProduct type from the dictionary.
/// The type adopts Codable so that it’s decodable using a instance of ``NotificationDeeplinkUserInfoDecoder``.
///
/// ```swift
/// struct GroceryProduct: Codable {
///     var name: String
///     var points: Int
///     var description: String?
/// }
///
/// let dictionary = [
///     "name": "Durian",
///     "points": 600,
///     "description": "A fruit with a distinctive scent."
/// ]
///
/// let decoder: NotificationDeeplinkUserInfoDecoder
/// let product = try decoder.decode(GroceryProduct.self, from: dictionary)
///
/// print(product.name) // Prints "Durian"
/// ```
///
/// - SeeAlso: ``NotificationDeeplink``
/// - SeeAlso: ``NotificationDeeplinkUserInfoOptions``
public protocol NotificationDeeplinkUserInfoDecoder {

    func decode<T: Decodable>(_ type: T.Type, from dictionary: [String: Any]) throws -> T
}

extension DictionaryDecoder: NotificationDeeplinkUserInfoDecoder { }
#endif
