import Foundation

internal struct URLQueryDecodingOptions {

    internal let dateDecodingStrategy: URLQueryDateDecodingStrategy
    internal let dataDecodingStrategy: URLQueryDataDecodingStrategy
    internal let nonConformingFloatDecodingStrategy: URLQueryNonConformingFloatDecodingStrategy
    internal let keyDecodingStrategy: URLQueryKeyDecodingStrategy
}
