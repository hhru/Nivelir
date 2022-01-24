import Foundation

internal enum DictionaryNonConformingFloatDecodingStrategy {

    case `throw`

    case convertFromString(
        positiveInfinity: String,
        negativeInfinity: String,
        nan: String
    )
}
