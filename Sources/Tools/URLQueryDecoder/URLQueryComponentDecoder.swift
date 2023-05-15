import Foundation

internal protocol URLQueryComponentDecoder {

    var options: URLQueryDecodingOptions { get }
    var userInfo: [CodingUserInfoKey: Any] { get }
}

extension URLQueryComponentDecoder {

    private func decodeNonPrimitiveValue<T: Decodable>(
        of type: T.Type = T.self,
        from component: URLQueryComponent?,
        at codingPath: [CodingKey]
    ) throws -> T {
        let decoder = URLQuerySingleValueDecodingContainer(
            component: component,
            options: options,
            userInfo: userInfo,
            codingPath: codingPath
        )

        return try T(from: decoder)
    }

    private func decodeCustomizedValue<T: Decodable>(
        of type: T.Type = T.self,
        from component: URLQueryComponent?,
        at codingPath: [CodingKey],
        closure: (_ decoder: Decoder) throws -> T
    ) throws -> T {
        let decoder = URLQuerySingleValueDecodingContainer(
            component: component,
            options: options,
            userInfo: userInfo,
            codingPath: codingPath
        )

        return try closure(decoder)
    }

    private func decodeString(
        from component: URLQueryComponent?,
        at codingPath: [CodingKey]
    ) throws -> String {
        guard let value = component?.string else {
            throw DecodingError.invalidComponent(
                component,
                of: String.self,
                at: codingPath
            )
        }

        return value
    }

    private func decodeBooleanValue(
        from component: URLQueryComponent?,
        at codingPath: [CodingKey]
    ) throws -> Bool {
        switch try decodeString(from: component, at: codingPath).lowercased() {
        case "1", "true":
            return true

        case "0", "false":
            return false

        default:
            throw DecodingError.invalidComponent(component, of: Bool.self, at: codingPath)
        }
    }

    private func decodeIntegerValue<T: FixedWidthInteger>(
        of type: T.Type = T.self,
        from component: URLQueryComponent?,
        at codingPath: [CodingKey]
    ) throws -> T {
        guard let value = T(try decodeString(from: component, at: codingPath)) else {
            throw DecodingError.invalidComponent(component, of: T.self, at: codingPath)
        }

        return value
    }

    private func decodeFloatingPointValue<T: FloatingPoint & LosslessStringConvertible>(
        of type: T.Type = T.self,
        from component: URLQueryComponent?,
        at codingPath: [CodingKey]
    ) throws -> T {
        let rawValue = try decodeString(from: component, at: codingPath)

        if let value = T(rawValue) {
            return value
        }

        switch options.nonConformingFloatDecodingStrategy {
        case let .convertFromString(positiveInfinity, _, _) where rawValue == positiveInfinity:
            return T.infinity

        case let .convertFromString(_, negativeInfinity, _) where rawValue == negativeInfinity:
            return -T.infinity

        case let .convertFromString(_, _, nan) where rawValue == nan:
            return T.nan

        case .convertFromString, .throw:
            throw DecodingError.invalidComponent(component, of: T.self, at: codingPath)
        }
    }

    private func decodeDate(from component: URLQueryComponent?, at codingPath: [CodingKey]) throws -> Date {
        switch options.dateDecodingStrategy {
        case .deferredToDate:
            return try decodeNonPrimitiveValue(from: component, at: codingPath)

        case .secondsSince1970:
            return Date(timeIntervalSince1970: try decodeFloatingPointValue(from: component, at: codingPath))

        case .millisecondsSince1970:
            return Date(timeIntervalSince1970: try decodeFloatingPointValue(from: component, at: codingPath) / 1000.0)

        case .iso8601:
            guard #available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *) else {
                fatalError("ISO8601DateFormatter is unavailable on this platform.")
            }

            let formattedDate = try decodeString(from: component, at: codingPath)

            guard let date = ISO8601DateFormatter().date(from: formattedDate) else {
                let errorContext = DecodingError.Context(
                    codingPath: codingPath,
                    debugDescription: "Expected date string to be ISO8601-formatted."
                )

                throw DecodingError.dataCorrupted(errorContext)
            }

            return date

        case .formatted(let dateFormatter):
            let formattedDate = try decodeString(from: component, at: codingPath)

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

    private func decodeData(from component: URLQueryComponent?, at codingPath: [CodingKey]) throws -> Data {
        switch options.dataDecodingStrategy {
        case .deferredToData:
            return try decodeNonPrimitiveValue(from: component, at: codingPath)

        case .base64:
            let base64EncodedString = try decodeString(from: component, at: codingPath)

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

    private func decodeURL(from component: URLQueryComponent?, at codingPath: [CodingKey]) throws -> URL {
        guard let url = URL(string: try decodeString(from: component, at: codingPath)) else {
            let errorContext = DecodingError.Context(
                codingPath: codingPath,
                debugDescription: "String is not valid URL."
            )

            throw DecodingError.dataCorrupted(errorContext)
        }

        return url
    }
}

extension URLQueryComponentDecoder {

    internal func decodeNilComponent(from component: URLQueryComponent?) -> Bool {
        component.isNil
    }

    internal func decodeComponentValue(
        from component: URLQueryComponent?,
        at codingPath: [CodingKey]
    ) throws -> Bool {
        try decodeBooleanValue(
            from: component,
            at: codingPath
        )
    }

    internal func decodeComponentValue(
        from component: URLQueryComponent?,
        at codingPath: [CodingKey]
    ) throws -> Int {
        try decodeIntegerValue(
            from: component,
            at: codingPath
        )
    }

    internal func decodeComponentValue(
        from component: URLQueryComponent?,
        at codingPath: [CodingKey]
    ) throws -> Int8 {
        try decodeIntegerValue(
            from: component,
            at: codingPath
        )
    }

    internal func decodeComponentValue(
        from component: URLQueryComponent?,
        at codingPath: [CodingKey]
    ) throws -> Int16 {
        try decodeIntegerValue(
            from: component,
            at: codingPath
        )
    }

    internal func decodeComponentValue(
        from component: URLQueryComponent?,
        at codingPath: [CodingKey]
    ) throws -> Int32 {
        try decodeIntegerValue(
            from: component,
            at: codingPath
        )
    }

    internal func decodeComponentValue(
        from component: URLQueryComponent?,
        at codingPath: [CodingKey]
    ) throws -> Int64 {
        try decodeIntegerValue(
            from: component,
            at: codingPath
        )
    }

    internal func decodeComponentValue(
        from component: URLQueryComponent?,
        at codingPath: [CodingKey]
    ) throws -> UInt {
        try decodeIntegerValue(
            from: component,
            at: codingPath
        )
    }

    internal func decodeComponentValue(
        from component: URLQueryComponent?,
        at codingPath: [CodingKey]
    ) throws -> UInt8 {
        try decodeIntegerValue(
            from: component,
            at: codingPath
        )
    }

    internal func decodeComponentValue(
        from component: URLQueryComponent?,
        at codingPath: [CodingKey]
    ) throws -> UInt16 {
        try decodeIntegerValue(
            from: component,
            at: codingPath
        )
    }

    internal func decodeComponentValue(
        from component: URLQueryComponent?,
        at codingPath: [CodingKey]
    ) throws -> UInt32 {
        try decodeIntegerValue(
            from: component,
            at: codingPath
        )
    }

    internal func decodeComponentValue(
        from component: URLQueryComponent?,
        at codingPath: [CodingKey]
    ) throws -> UInt64 {
        try decodeIntegerValue(
            from: component,
            at: codingPath
        )
    }

    internal func decodeComponentValue(
        from component: URLQueryComponent?,
        at codingPath: [CodingKey]
    ) throws -> Double {
        try decodeFloatingPointValue(
            from: component,
            at: codingPath
        )
    }

    internal func decodeComponentValue(
        from component: URLQueryComponent?,
        at codingPath: [CodingKey]
    ) throws -> Float {
        try decodeFloatingPointValue(
            from: component,
            at: codingPath
        )
    }

    internal func decodeComponentValue(
        from component: URLQueryComponent?,
        at codingPath: [CodingKey]
    ) throws -> String {
        try decodeString(
            from: component,
            at: codingPath
        )
    }

    internal func decodeComponentValue<T: Decodable>(
        of type: T.Type,
        from component: URLQueryComponent?,
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
        _ component: URLQueryComponent?,
        of type: Any.Type,
        at codingPath: [CodingKey]
    ) -> DecodingError {
        let componentDescription = component == nil
            ? "nil"
            : "invalid"

        let context = DecodingError.Context(
            codingPath: codingPath,
            debugDescription: "Expected to decode \(type) but the value is \(componentDescription)."
        )

        return .typeMismatch(type, context)
    }
}
