import Foundation

internal protocol DictionaryComponentDecoder {

    var options: DictionaryDecodingOptions { get }
    var userInfo: [CodingUserInfoKey: Any] { get }
    var codingPath: [CodingKey] { get }
}

extension DictionaryComponentDecoder {

    private func decodePrimitiveValue<T: Decodable>(from component: Any?, as type: T.Type = T.self) throws -> T {
        guard let value = component as? T else {
            throw DecodingError.invalidComponent(component, at: codingPath, expectation: T.self)
        }

        return value
    }

    private func decodeNonPrimitiveValue<T: Decodable>(from component: Any?, as type: T.Type = T.self) throws -> T {
        let decoder = DictionarySingleValueDecodingContainer(
            component: component,
            options: options,
            userInfo: userInfo,
            codingPath: codingPath
        )

        return try T(from: decoder)
    }

    private func decodeCustomizedValue<T: Decodable>(
        from component: Any?,
        as type: T.Type = T.self,
        closure: (_ decoder: Decoder) throws -> T
    ) throws -> T {
        let decoder = DictionarySingleValueDecodingContainer(
            component: component,
            options: options,
            userInfo: userInfo,
            codingPath: codingPath
        )

        return try closure(decoder)
    }

    private func decodeDate(from component: Any?) throws -> Date {
        switch self.options.dateDecodingStrategy {
        case .deferredToDate:
            return try decodeNonPrimitiveValue(from: component)

        case .secondsSince1970:
            return Date(timeIntervalSince1970: try decodePrimitiveValue(from: component))

        case .millisecondsSince1970:
            return Date(timeIntervalSince1970: try decodePrimitiveValue(from: component) / 1000.0)

        case .iso8601:
            guard #available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *) else {
                fatalError("ISO8601DateFormatter is unavailable on this platform.")
            }

            let formattedDate = try decodePrimitiveValue(from: component, as: String.self)

            guard let date = ISO8601DateFormatter().date(from: formattedDate) else {
                let errorContext = DecodingError.Context(
                    codingPath: codingPath,
                    debugDescription: "Expected date string to be ISO8601-formatted."
                )

                throw DecodingError.dataCorrupted(errorContext)
            }

            return date

        case .formatted(let dateFormatter):
            let formattedDate = try decodePrimitiveValue(from: component, as: String.self)

            guard let date = dateFormatter.date(from: formattedDate) else {
                let errorContext = DecodingError.Context(
                    codingPath: codingPath,
                    debugDescription: "Date string does not match format expected by formatter."
                )

                throw DecodingError.dataCorrupted(errorContext)
            }

            return date

        case .custom(let closure):
            return try decodeCustomizedValue(from: component, closure: closure)
        }
    }

    private func decodeData(from component: Any?) throws -> Data {
        switch self.options.dataDecodingStrategy {
        case .deferredToData:
            return try decodeNonPrimitiveValue(from: component)

        case .base64:
            let base64EncodedString = try decodePrimitiveValue(from: component, as: String.self)

            guard let data = Data(base64Encoded: base64EncodedString) else {
                let errorContext = DecodingError.Context(
                    codingPath: codingPath,
                    debugDescription: "Encountered Data is not valid Base64."
                )

                throw DecodingError.dataCorrupted(errorContext)
            }

            return data

        case .custom(let closure):
            return try decodeCustomizedValue(from: component, closure: closure)
        }
    }

    private func decodeFloatingPoint<T: FloatingPoint & Decodable>(from component: Any?) throws -> T {
        switch component {
        case let string as String:
            switch options.nonConformingFloatDecodingStrategy {
            case let .convertFromString(positiveInfinity, _, _) where string == positiveInfinity:
                return T.infinity

            case let .convertFromString(_, negativeInfinity, _) where string == negativeInfinity:
                return -T.infinity

            case let .convertFromString(_, _, nan) where string == nan:
                return T.nan

            case .convertFromString, .throw:
                break
            }

        case let number as T where number.isFinite:
            return number

        case let number as T:
            let errorContext = DecodingError.Context(
                codingPath: codingPath,
                debugDescription: "Parsed dictionary number \(number) does not fit in \(T.self)."
            )

            throw DecodingError.dataCorrupted(errorContext)

        default:
            break
        }

        throw DecodingError.invalidComponent(component, at: codingPath, expectation: T.self)
    }

    private func decodeURL(from component: Any?) throws -> URL {
        guard let url = URL(string: try decodePrimitiveValue(from: component)) else {
            let errorContext = DecodingError.Context(
                codingPath: codingPath,
                debugDescription: "String is not valid URL."
            )

            throw DecodingError.dataCorrupted(errorContext)
        }

        return url
    }
}

extension DictionaryComponentDecoder {

    internal func decodeNilComponent(_ component: Any?) -> Bool {
        component.isNil || component is NSNull
    }

    internal func decodeComponentValue(_ component: Any?) throws -> Bool {
        try decodePrimitiveValue(from: component)
    }

    internal func decodeComponentValue(_ component: Any?) throws -> Int {
        try decodePrimitiveValue(from: component)
    }

    internal func decodeComponentValue(_ component: Any?) throws -> Int8 {
        try decodePrimitiveValue(from: component)
    }

    internal func decodeComponentValue(_ component: Any?) throws -> Int16 {
        try decodePrimitiveValue(from: component)
    }

    internal func decodeComponentValue(_ component: Any?) throws -> Int32 {
        try decodePrimitiveValue(from: component)
    }

    internal func decodeComponentValue(_ component: Any?) throws -> Int64 {
        try decodePrimitiveValue(from: component)
    }

    internal func decodeComponentValue(_ component: Any?) throws -> UInt {
        try decodePrimitiveValue(from: component)
    }

    internal func decodeComponentValue(_ component: Any?) throws -> UInt8 {
        try decodePrimitiveValue(from: component)
    }

    internal func decodeComponentValue(_ component: Any?) throws -> UInt16 {
        try decodePrimitiveValue(from: component)
    }

    internal func decodeComponentValue(_ component: Any?) throws -> UInt32 {
        try decodePrimitiveValue(from: component)
    }

    internal func decodeComponentValue(_ component: Any?) throws -> UInt64 {
        try decodePrimitiveValue(from: component)
    }

    internal func decodeComponentValue(_ component: Any?) throws -> Double {
        try decodeFloatingPoint(from: component)
    }

    internal func decodeComponentValue(_ component: Any?) throws -> Float {
        try decodeFloatingPoint(from: component)
    }

    internal func decodeComponentValue(_ component: Any?) throws -> String {
        try decodePrimitiveValue(from: component)
    }

    internal func decodeComponentValue<T: Decodable>(_ component: Any?, as type: T.Type) throws -> T {
        switch T.self {
        case is Date.Type:
            return try decodeDate(from: component) as! T

        case is Data.Type:
            return try decodeData(from: component) as! T

        case is URL.Type:
            return try decodeURL(from: component) as! T

        default:
            return try decodeNonPrimitiveValue(from: component)
        }
    }
}

private extension DecodingError {

    static func invalidComponent(
        _ component: Any?,
        at codingPath: [CodingKey],
        expectation: Any.Type
    ) -> DecodingError {
        let typeDescription: String

        switch component {
        case let component?:
            typeDescription = "\(type(of: component))"

        case nil:
            typeDescription = "nil"
        }

        let debugDescription = "Expected to decode \(expectation) but found \(typeDescription) instead."

        return .typeMismatch(expectation, Context(codingPath: codingPath, debugDescription: debugDescription))
    }
}
