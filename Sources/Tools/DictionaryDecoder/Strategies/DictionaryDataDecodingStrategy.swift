import Foundation

internal enum DictionaryDataDecodingStrategy {

    case deferredToData
    case base64
    case custom((_ decoder: Decoder) throws -> Data)
}
