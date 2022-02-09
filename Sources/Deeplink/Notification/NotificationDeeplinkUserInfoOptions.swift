#if os(iOS)
import Foundation

public struct NotificationDeeplinkUserInfoOptions {

    public let dateDecodingStrategy: DictionaryDateDecodingStrategy
    public let dataDecodingStrategy: DictionaryDataDecodingStrategy
    public let nonConformingFloatDecodingStrategy: DictionaryNonConformingFloatDecodingStrategy
    public let keyDecodingStrategy: DictionaryKeyDecodingStrategy
    public let userInfo: [CodingUserInfoKey: Any]

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
#endif
