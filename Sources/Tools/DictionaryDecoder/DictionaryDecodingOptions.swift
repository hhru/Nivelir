import Foundation

internal struct DictionaryDecodingOptions {

    internal let dateDecodingStrategy: DictionaryDateDecodingStrategy
    internal let dataDecodingStrategy: DictionaryDataDecodingStrategy
    internal let nonConformingFloatDecodingStrategy: DictionaryNonConformingFloatDecodingStrategy
    internal let keyDecodingStrategy: DictionaryKeyDecodingStrategy
}
