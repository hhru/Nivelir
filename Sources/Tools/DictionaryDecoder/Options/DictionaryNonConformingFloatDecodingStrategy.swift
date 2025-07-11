import Foundation

/// The strategies for encoding nonconforming floating-point numbers,
/// also known as IEEE 754 exceptional values.
@frozen
public enum DictionaryNonConformingFloatDecodingStrategy {

    /// The strategy that throws an error upon decoding an exceptional floating-point value.
    case `throw`

    /// The strategy that decodes exceptional floating-point values from a specified string representation.
    case convertFromString(
        positiveInfinity: String,
        negativeInfinity: String,
        nan: String
    )
}
