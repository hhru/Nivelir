import Foundation

internal struct DictionaryDecoder {

    @MainActor
    internal static let `default` = Self()

    internal var dateDecodingStrategy: DictionaryDateDecodingStrategy
    internal var dataDecodingStrategy: DictionaryDataDecodingStrategy
    internal var nonConformingFloatDecodingStrategy: DictionaryNonConformingFloatDecodingStrategy
    internal var keyDecodingStrategy: DictionaryKeyDecodingStrategy
    internal var userInfo: [CodingUserInfoKey: Any]

    internal init(
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

    internal func decode<T: Decodable>(_ type: T.Type, from dictionary: [String: Any]) throws -> T {
        let options = DictionaryDecodingOptions(
            dateDecodingStrategy: dateDecodingStrategy,
            dataDecodingStrategy: dataDecodingStrategy,
            nonConformingFloatDecodingStrategy: nonConformingFloatDecodingStrategy,
            keyDecodingStrategy: keyDecodingStrategy
        )

        let decoder = DictionarySingleValueDecodingContainer(
            component: dictionary,
            options: options,
            userInfo: userInfo,
            codingPath: []
        )

        return try T(from: decoder)
    }

    internal func decode<T: Decodable>(from dictionary: [String: Any]) throws -> T {
        try decode(T.self, from: dictionary)
    }
}
