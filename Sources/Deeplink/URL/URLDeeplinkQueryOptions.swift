import Foundation

public struct URLDeeplinkQueryOptions {

    public let dateDecodingStrategy: URLQueryDateDecodingStrategy
    public let dataDecodingStrategy: URLQueryDataDecodingStrategy
    public let nonConformingFloatDecodingStrategy: URLQueryNonConformingFloatDecodingStrategy
    public let keyDecodingStrategy: URLQueryKeyDecodingStrategy
    public let userInfo: [CodingUserInfoKey: Any]

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
