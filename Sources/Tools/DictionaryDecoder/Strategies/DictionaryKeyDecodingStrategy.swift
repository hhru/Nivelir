import Foundation

internal enum DictionaryKeyDecodingStrategy {

    case useDefaultKeys
    case custom((_ codingPath: [CodingKey]) -> CodingKey)
}
