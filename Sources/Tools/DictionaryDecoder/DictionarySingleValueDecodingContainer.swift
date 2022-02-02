import Foundation

internal final class DictionarySingleValueDecodingContainer: DictionaryComponentDecoder {

    internal let component: Any?
    internal let options: DictionaryDecodingOptions
    internal let userInfo: [CodingUserInfoKey: Any]
    internal let codingPath: [CodingKey]

    internal init(
        component: Any?,
        options: DictionaryDecodingOptions,
        userInfo: [CodingUserInfoKey: Any],
        codingPath: [CodingKey]
    ) {
        self.component = component
        self.options = options
        self.userInfo = userInfo
        self.codingPath = codingPath
    }
}

extension DictionarySingleValueDecodingContainer: SingleValueDecodingContainer {

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

extension DictionarySingleValueDecodingContainer: Decoder {

    internal func container<Key: CodingKey>(keyedBy keyType: Key.Type) throws -> KeyedDecodingContainer<Key> {
        guard let components = component as? [String: Any] else {
            throw DecodingError.keyedContainerTypeMismatch(at: codingPath, component: component)
        }

        let container = DictionaryKeyedDecodingContainer<Key>(
            components: components,
            options: options,
            userInfo: userInfo,
            codingPath: codingPath
        )

        return KeyedDecodingContainer(container)
    }

    internal func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        guard let components = component as? [Any?] else {
            throw DecodingError.unkeyedContainerTypeMismatch(at: codingPath, component: component)
        }

        return DictionaryUnkeyedDecodingContainer(
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

private extension DecodingError {

    static func keyedContainerTypeMismatch(
        at codingPath: [CodingKey],
        component: Any?
    ) -> Self {
        let debugDescription: String

        switch component {
        case let value?:
            debugDescription = "Expected to decode \([String: Any].self) but found \(type(of: value)) instead."

        case nil:
            debugDescription = "Cannot get keyed decoding container -- found null value instead."
        }

        return .typeMismatch([String: Any].self, Context(codingPath: codingPath, debugDescription: debugDescription))
    }

    static func unkeyedContainerTypeMismatch(
        at codingPath: [CodingKey],
        component: Any?
    ) -> Self {
        let debugDescription: String

        switch component {
        case let value?:
            debugDescription = "Expected to decode \([Any].self) but found \(type(of: value)) instead."

        case nil:
            debugDescription = "Cannot get unkeyed decoding container -- found null value instead."
        }

        return .typeMismatch([Any].self, Context(codingPath: codingPath, debugDescription: debugDescription))
    }
}
