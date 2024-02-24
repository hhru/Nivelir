import Foundation

internal protocol DictionaryComponentDecoder {

    var options: DictionaryDecodingOptions { get }
    var userInfo: [CodingUserInfoKey: Any] { get }
}

extension DictionaryComponentDecoder {

    private func decodePrimitiveValue<T: Decodable>(
        of type: T.Type = T.self,
        from component: Any?,
        at codingPath: [CodingKey]
    ) throws -> T {
        guard let value = component as? T else {
            throw DecodingError.invalidComponent(component, of: T.self, at: codingPath)
        }

        return value
    }

    private func decodeNonPrimitiveValue<T: Decodable>(
        of type: T.Type = T.self,
        from component: Any?,
        at codingPath: [CodingKey]
    ) throws -> T {
        let decoder = DictionarySingleValueDecodingContainer(
            component: component,
            options: options,
            userInfo: userInfo,
            codingPath: codingPath
        )

        return try T(from: decoder)
    }

    private func decodeCustomizedValue<T: Decodable>(
        of type: T.Type = T.self,
        from component: Any?,
        at codingPath: [CodingKey],
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

    private func decodeFloatingPointValue<T: FloatingPoint & Decodable>(
        from component: Any?,
        at codingPath: [CodingKey]
    ) throws -> T {
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

        throw DecodingError.invalidComponent(component, of: T.self, at: codingPath)
    }

    private func decodeDate(from component: Any?, at codingPath: [CodingKey]) throws -> Date {
        switch options.dateDecodingStrategy {
        case .deferredToDate:
            return try decodeNonPrimitiveValue(from: component, at: codingPath)

        case .secondsSince1970:
            return Date(timeIntervalSince1970: try decodePrimitiveValue(from: component, at: codingPath))

        case .millisecondsSince1970:
            return Date(timeIntervalSince1970: try decodePrimitiveValue(from: component, at: codingPath) / 1000.0)

        case .iso8601:
            guard #available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *) else {
                fatalError("ISO8601DateFormatter is unavailable on this platform.")
            }

            let formattedDate = try decodePrimitiveValue(of: String.self, from: component, at: codingPath)

            guard let date = ISO8601DateFormatter().date(from: formattedDate) else {
                let errorContext = DecodingError.Context(
                    codingPath: codingPath,
                    debugDescription: "Expected date string to be ISO8601-formatted."
                )

                throw DecodingError.dataCorrupted(errorContext)
            }

            return date

        case .formatted(let dateFormatter):
            let formattedDate = try decodePrimitiveValue(of: String.self, from: component, at: codingPath)

            guard let date = dateFormatter.date(from: formattedDate) else {
                let errorContext = DecodingError.Context(
                    codingPath: codingPath,
                    debugDescription: "Date string does not match format expected by formatter."
                )

                throw DecodingError.dataCorrupted(errorContext)
            }

            return date

        case .custom(let closure):
            return try decodeCustomizedValue(from: component, at: codingPath, closure: closure)
        }
    }

    private func decodeData(from component: Any?, at codingPath: [CodingKey]) throws -> Data {
        switch options.dataDecodingStrategy {
        case .deferredToData:
            return try decodeNonPrimitiveValue(from: component, at: codingPath)

        case .base64:
            let base64EncodedString = try decodePrimitiveValue(of: String.self, from: component, at: codingPath)

            guard let data = Data(base64Encoded: base64EncodedString) else {
                let errorContext = DecodingError.Context(
                    codingPath: codingPath,
                    debugDescription: "Encountered Data is not valid Base64."
                )

                throw DecodingError.dataCorrupted(errorContext)
            }

            return data

        case .custom(let closure):
            return try decodeCustomizedValue(from: component, at: codingPath, closure: closure)
        }
    }

    private func decodeURL(from component: Any?, at codingPath: [CodingKey]) throws -> URL {
        if let url = component as? URL {
            return url
        }

        guard let url = URL(string: try decodePrimitiveValue(from: component, at: codingPath)) else {
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

    internal func decodeNilComponent(from component: Any?) -> Bool {
        component.isNil || component is NSNull
    }

    internal func decodeComponentValue(from component: Any?, at codingPath: [CodingKey]) throws -> Bool {
        try decodePrimitiveValue(from: component, at: codingPath)
    }

    internal func decodeComponentValue(from component: Any?, at codingPath: [CodingKey]) throws -> Int {
        try decodePrimitiveValue(from: component, at: codingPath)
    }

    internal func decodeComponentValue(from component: Any?, at codingPath: [CodingKey]) throws -> Int8 {
        try decodePrimitiveValue(from: component, at: codingPath)
    }

    internal func decodeComponentValue(from component: Any?, at codingPath: [CodingKey]) throws -> Int16 {
        try decodePrimitiveValue(from: component, at: codingPath)
    }

    internal func decodeComponentValue(from component: Any?, at codingPath: [CodingKey]) throws -> Int32 {
        try decodePrimitiveValue(from: component, at: codingPath)
    }

    internal func decodeComponentValue(from component: Any?, at codingPath: [CodingKey]) throws -> Int64 {
        try decodePrimitiveValue(from: component, at: codingPath)
    }

    internal func decodeComponentValue(from component: Any?, at codingPath: [CodingKey]) throws -> UInt {
        try decodePrimitiveValue(from: component, at: codingPath)
    }

    internal func decodeComponentValue(from component: Any?, at codingPath: [CodingKey]) throws -> UInt8 {
        try decodePrimitiveValue(from: component, at: codingPath)
    }

    internal func decodeComponentValue(from component: Any?, at codingPath: [CodingKey]) throws -> UInt16 {
        try decodePrimitiveValue(from: component, at: codingPath)
    }

    internal func decodeComponentValue(from component: Any?, at codingPath: [CodingKey]) throws -> UInt32 {
        try decodePrimitiveValue(from: component, at: codingPath)
    }

    internal func decodeComponentValue(from component: Any?, at codingPath: [CodingKey]) throws -> UInt64 {
        try decodePrimitiveValue(from: component, at: codingPath)
    }

    internal func decodeComponentValue(from component: Any?, at codingPath: [CodingKey]) throws -> Double {
        try decodeFloatingPointValue(from: component, at: codingPath)
    }

    internal func decodeComponentValue(from component: Any?, at codingPath: [CodingKey]) throws -> Float {
        try decodeFloatingPointValue(from: component, at: codingPath)
    }

    internal func decodeComponentValue(from component: Any?, at codingPath: [CodingKey]) throws -> String {
        try decodePrimitiveValue(from: component, at: codingPath)
    }

    internal func decodeComponentValue<T: Decodable>(
        of type: T.Type,
        from component: Any?,
        at codingPath: [CodingKey]
    ) throws -> T {
        switch T.self {
        case is Date.Type:
            return try decodeDate(from: component, at: codingPath) as! T

        case is Data.Type:
            return try decodeData(from: component, at: codingPath) as! T

        case is URL.Type:
            return try decodeURL(from: component, at: codingPath) as! T

        default:
            return try decodeNonPrimitiveValue(from: component, at: codingPath)
        }
    }
}

extension DecodingError {

    fileprivate static func invalidComponent(
        _ component: Any?,
        of expectedType: Any.Type,
        at codingPath: [CodingKey]
    ) -> DecodingError {
        let componentDescription = component.map { "\(type(of: $0))" } ?? "nil"

        let context = Context(
            codingPath: codingPath,
            debugDescription: "Expected to decode \(expectedType) but found \(componentDescription) instead."
        )

        return .typeMismatch(expectedType, context)
    }
}
