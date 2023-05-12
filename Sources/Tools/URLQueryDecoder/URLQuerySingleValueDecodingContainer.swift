import Foundation

internal final class URLQuerySingleValueDecodingContainer: URLQueryComponentDecoder {

    internal let component: URLQueryComponent?
    internal let options: URLQueryDecodingOptions
    internal let userInfo: [CodingUserInfoKey: Any]
    internal let codingPath: [CodingKey]

    internal init(
        component: URLQueryComponent?,
        options: URLQueryDecodingOptions,
        userInfo: [CodingUserInfoKey: Any],
        codingPath: [CodingKey]
    ) {
        self.component = component
        self.options = options
        self.userInfo = userInfo
        self.codingPath = codingPath
    }
}

extension URLQuerySingleValueDecodingContainer: SingleValueDecodingContainer {

    internal func decodeNil() -> Bool {
        decodeNilComponent(from: component)
    }

    internal func decode(_ type: Bool.Type) throws -> Bool {
        try decodeComponentValue(from: component, at: codingPath)
    }

    internal func decode(_ type: Int.Type) throws -> Int {
        try decodeComponentValue(from: component, at: codingPath)
    }

    internal func decode(_ type: Int8.Type) throws -> Int8 {
        try decodeComponentValue(from: component, at: codingPath)
    }

    internal func decode(_ type: Int16.Type) throws -> Int16 {
        try decodeComponentValue(from: component, at: codingPath)
    }

    internal func decode(_ type: Int32.Type) throws -> Int32 {
        try decodeComponentValue(from: component, at: codingPath)
    }

    internal func decode(_ type: Int64.Type) throws -> Int64 {
        try decodeComponentValue(from: component, at: codingPath)
    }

    internal func decode(_ type: UInt.Type) throws -> UInt {
        try decodeComponentValue(from: component, at: codingPath)
    }

    internal func decode(_ type: UInt8.Type) throws -> UInt8 {
        try decodeComponentValue(from: component, at: codingPath)
    }

    internal func decode(_ type: UInt16.Type) throws -> UInt16 {
        try decodeComponentValue(from: component, at: codingPath)
    }

    internal func decode(_ type: UInt32.Type) throws -> UInt32 {
        try decodeComponentValue(from: component, at: codingPath)
    }

    internal func decode(_ type: UInt64.Type) throws -> UInt64 {
        try decodeComponentValue(from: component, at: codingPath)
    }

    internal func decode(_ type: Double.Type) throws -> Double {
        try decodeComponentValue(from: component, at: codingPath)
    }

    internal func decode(_ type: Float.Type) throws -> Float {
        try decodeComponentValue(from: component, at: codingPath)
    }

    internal func decode(_ type: String.Type) throws -> String {
        try decodeComponentValue(from: component, at: codingPath)
    }

    internal func decode<T: Decodable>(_ type: T.Type) throws -> T {
        try decodeComponentValue(of: type, from: component, at: codingPath)
    }
}

extension URLQuerySingleValueDecodingContainer: Decoder {

    internal func container<Key: CodingKey>(keyedBy keyType: Key.Type) throws -> KeyedDecodingContainer<Key> {
        guard let components = component?.dictionary else {
            throw DecodingError.keyedContainerTypeMismatch(at: codingPath, component: component)
        }

        let container = URLQueryKeyedDecodingContainer<Key>(
            components: components,
            options: options,
            userInfo: userInfo,
            codingPath: codingPath
        )

        return KeyedDecodingContainer(container)
    }

    internal func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        guard let components = component?.array else {
            throw DecodingError.unkeyedContainerTypeMismatch(at: codingPath, component: component)
        }

        return URLQueryUnkeyedDecodingContainer(
            components: components,
            options: options,
            userInfo: userInfo,
            codingPath: codingPath
        )
    }

    internal func singleValueContainer() throws -> SingleValueDecodingContainer {
        self
    }
}

extension DecodingError {

    fileprivate static func keyedContainerTypeMismatch(
        at codingPath: [CodingKey],
        component: URLQueryComponent?
    ) -> Self {
        let debugDescription: String

        switch component {
        case .string:
            debugDescription = "Expected to decode a dictionary but found string instead."

        case .array:
            debugDescription = "Expected to decode a dictionary but found array instead."

        case .dictionary:
            debugDescription = "Cannot get keyed decoding container."

        case nil:
            debugDescription = "Cannot get keyed decoding container -- found null value instead."
        }

        return .typeMismatch([String: Any].self, Context(codingPath: codingPath, debugDescription: debugDescription))
    }

    fileprivate static func unkeyedContainerTypeMismatch(
        at codingPath: [CodingKey],
        component: URLQueryComponent?
    ) -> Self {
        let debugDescription: String

        switch component {
        case .string:
            debugDescription = "Expected to decode an array but found string instead."

        case .dictionary:
            debugDescription = "Expected to decode an array but found dictionary instead."

        case .array:
            debugDescription = "Cannot get unkeyed decoding container."

        case nil:
            debugDescription = "Cannot get unkeyed decoding container -- found null value instead."
        }

        let context = Context(
            codingPath: codingPath,
            debugDescription: debugDescription
        )

        return .typeMismatch([Any].self, context)
    }
}
