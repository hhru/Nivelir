import Foundation

/// The strategies available for formatting dates when decoding them from Dictionary.
@frozen
public enum DictionaryDateDecodingStrategy {

    /// The strategy that uses formatting from the Date structure.
    case deferredToDate

    /// The strategy that decodes dates in terms of seconds since midnight UTC on January 1st, 1970.
    case secondsSince1970

    /// The strategy that decodes dates in terms of milliseconds since midnight UTC on January 1st, 1970.
    case millisecondsSince1970

    /// The strategy that formats dates according to the ISO 8601 standard.
    @available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
    case iso8601

    /// The strategy that defers formatting settings to a supplied date formatter.
    case formatted(DateFormatter)

    /// The strategy that formats custom dates by calling a user-defined function.
    case custom(@Sendable (_ decoder: Decoder) throws -> Date)
}
