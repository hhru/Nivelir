import Foundation

/// A type that decodes instances of a data type from URL query part.
///
/// The example below shows how to decode an instance of a simple GroceryProduct type from the URL query part.
/// The type adopts Codable so that it’s decodable using a instance of ``URLDeeplinkQueryDecoder``.
///
/// ```swift
/// struct GroceryProduct: Codable {
///     var name: String
///     var points: Int
///     var description: String?
/// }
///
/// let url = URL(
///     string: "nivelir://grocery/product?name=Durian&points=600&description=A+fruit+with+a+distinctive+scent."
/// )!
///
/// let decoder: URLDeeplinkQueryDecoder
/// let product = try decoder.decode(GroceryProduct.self, from: url.query!)
///
/// print(product.name) // Prints "Durian"
/// ```
///
/// - SeeAlso: ``URLDeeplink``
/// - SeeAlso: ``URLDeeplinkQueryOptions``
public protocol URLDeeplinkQueryDecoder {

    /// Returns a value of the type you specify, decoded from a query part of URL.
    ///
    /// If the query isn’t valid, this method throws the `DecodingError.dataCorrupted(_:)` error.
    /// If a value within the query fails to decode, this method throws the corresponding error.
    /// - Parameters:
    ///   - type: The type of the value to decode from the supplied query part of URL.
    ///   - query: The query part of URL to decode.
    /// - Returns: A value of the specified type, if the decoder can parse the data.
    func decode<T: Decodable>(
        _ type: T.Type,
        from query: String
    ) throws -> T
}

extension URLQueryDecoder: URLDeeplinkQueryDecoder { }
