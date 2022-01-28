import Foundation

internal struct URLQueryDecoder {

    internal static let `default` = URLQueryDecoder()

    internal var dateDecodingStrategy: URLQueryDateDecodingStrategy
    internal var dataDecodingStrategy: URLQueryDataDecodingStrategy
    internal var nonConformingFloatDecodingStrategy: URLQueryNonConformingFloatDecodingStrategy
    internal var keyDecodingStrategy: URLQueryKeyDecodingStrategy
    internal var userInfo: [CodingUserInfoKey: Any]

    internal init(
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

    internal func decode<T: Decodable>(
        _ type: T.Type,
        from query: String
    ) throws -> T {
        let options = URLQueryDecodingOptions(
            dateDecodingStrategy: dateDecodingStrategy,
            dataDecodingStrategy: dataDecodingStrategy,
            nonConformingFloatDecodingStrategy: nonConformingFloatDecodingStrategy,
            keyDecodingStrategy: keyDecodingStrategy
        )

        let deserializer = URLQueryDeserializer()
        let component = try deserializer.deserialize(query)

        let decoder = URLQuerySingleValueDecodingContainer(
            component: component,
            options: options,
            userInfo: userInfo,
            codingPath: []
        )

        return try T(from: decoder)
    }
}
