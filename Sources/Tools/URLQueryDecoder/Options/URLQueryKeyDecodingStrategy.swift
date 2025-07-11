import Foundation

/// The values that determine how to decode a type’s coding keys from URL query keys.
@frozen
public enum URLQueryKeyDecodingStrategy {

    /// A key decoding strategy that doesn’t change key names during decoding.
    case useDefaultKeys

    /// A key decoding strategy defined by the closure you supply.
    case custom((_ codingPath: [CodingKey]) -> CodingKey)
}
