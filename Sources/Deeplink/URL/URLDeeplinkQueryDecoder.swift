import Foundation

public protocol URLDeeplinkQueryDecoder {

    func decode<T: Decodable>(
        _ type: T.Type,
        from query: String
    ) throws -> T
}

extension URLQueryDecoder: URLDeeplinkQueryDecoder { }
