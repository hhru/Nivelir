import Foundation

internal enum DictionaryDateDecodingStrategy {

    case deferredToDate

    case secondsSince1970
    case millisecondsSince1970

    @available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
    case iso8601

    case formatted(DateFormatter)
    case custom((_ decoder: Decoder) throws -> Date)
}
