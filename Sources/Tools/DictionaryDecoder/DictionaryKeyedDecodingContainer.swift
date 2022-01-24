import Foundation

internal class DictionaryKeyedDecodingContainer<Key: CodingKey>: DictionaryComponentDecoder {

    internal let components: [String: Any]
    internal let options: DictionaryDecodingOptions
    internal let userInfo: [CodingUserInfoKey: Any]

    internal private(set) var codingPath: [CodingKey]

    internal init(
        components: [String: Any],
        options: DictionaryDecodingOptions,
        userInfo: [CodingUserInfoKey: Any],
        codingPath: [CodingKey]
    ) {
        switch options.keyDecodingStrategy {
        case .useDefaultKeys:
            self.components = components

        case let.custom(closure):
            let componentKeysAndValues = components.map { key, value in
                (closure(codingPath.appending(AnyCodingKey(key))).stringValue, value)
            }

            self.components = Dictionary(componentKeysAndValues) { $1 }
        }

        self.options = options
        self.userInfo = userInfo
        self.codingPath = codingPath
    }

    private func component<T>(of type: T.Type = T.self, forKey key: Key) throws -> T {
        let anyComponent = components[key.stringValue]

        guard let component = anyComponent as? T else {
            throw DecodingError.invalidComponent(
                anyComponent,
                forKey: key,
                at: codingPath,
                expectation: type
            )
        }

        return component
    }

    private func superDecoder(forAnyKey key: CodingKey) throws -> Decoder {
        let decoder = DictionarySingleValueDecodingContainer(
            component: components[key.stringValue],
            options: options,
            userInfo: userInfo,
            codingPath: codingPath.appending(key)
        )

        return decoder
    }
}

extension DictionaryKeyedDecodingContainer: KeyedDecodingContainerProtocol {

    internal var allKeys: [Key] {
        components.keys.compactMap { Key(stringValue: $0) }
    }

    internal func contains(_ key: Key) -> Bool {
        components.contains { $0.key == key.stringValue }
    }

    internal func decodeNil(forKey key: Key) throws -> Bool {
        decodeNilComponent(try component(forKey: key))
    }

    internal func decode(_ type: Bool.Type, forKey key: Key) throws -> Bool {
        codingPath.append(key)

        defer {
            codingPath.removeLast()
        }

        return try decodeComponentValue(try component(forKey: key))
    }

    internal func decode(_ type: Int.Type, forKey key: Key) throws -> Int {
        codingPath.append(key)

        defer {
            codingPath.removeLast()
        }

        return try decodeComponentValue(try component(forKey: key))
    }

    internal func decode(_ type: Int8.Type, forKey key: Key) throws -> Int8 {
        codingPath.append(key)

        defer {
            codingPath.removeLast()
        }

        return try decodeComponentValue(try component(forKey: key))
    }

    internal func decode(_ type: Int16.Type, forKey key: Key) throws -> Int16 {
        codingPath.append(key)

        defer {
            codingPath.removeLast()
        }

        return try decodeComponentValue(try component(forKey: key))
    }

    internal func decode(_ type: Int32.Type, forKey key: Key) throws -> Int32 {
        codingPath.append(key)

        defer {
            codingPath.removeLast()
        }

        return try decodeComponentValue(try component(forKey: key))
    }

    internal func decode(_ type: Int64.Type, forKey key: Key) throws -> Int64 {
        codingPath.append(key)

        defer {
            codingPath.removeLast()
        }

        return try decodeComponentValue(try component(forKey: key))
    }

    internal func decode(_ type: UInt.Type, forKey key: Key) throws -> UInt {
        codingPath.append(key)

        defer {
            codingPath.removeLast()
        }

        return try decodeComponentValue(try component(forKey: key))
    }

    internal func decode(_ type: UInt8.Type, forKey key: Key) throws -> UInt8 {
        codingPath.append(key)

        defer {
            codingPath.removeLast()
        }

        return try decodeComponentValue(try component(forKey: key))
    }

    internal func decode(_ type: UInt16.Type, forKey key: Key) throws -> UInt16 {
        codingPath.append(key)

        defer {
            codingPath.removeLast()
        }

        return try decodeComponentValue(try component(forKey: key))
    }

    internal func decode(_ type: UInt32.Type, forKey key: Key) throws -> UInt32 {
        codingPath.append(key)

        defer {
            codingPath.removeLast()
        }

        return try decodeComponentValue(try component(forKey: key))
    }

    internal func decode(_ type: UInt64.Type, forKey key: Key) throws -> UInt64 {
        codingPath.append(key)

        defer {
            codingPath.removeLast()
        }

        return try decodeComponentValue(try component(forKey: key))
    }

    internal func decode(_ type: Double.Type, forKey key: Key) throws -> Double {
        codingPath.append(key)

        defer {
            codingPath.removeLast()
        }

        return try decodeComponentValue(try component(forKey: key))
    }

    internal func decode(_ type: Float.Type, forKey key: Key) throws -> Float {
        codingPath.append(key)

        defer {
            codingPath.removeLast()
        }

        return try decodeComponentValue(try component(forKey: key))
    }

    internal func decode(_ type: String.Type, forKey key: Key) throws -> String {
        codingPath.append(key)

        defer {
            codingPath.removeLast()
        }

        return try decodeComponentValue(try component(forKey: key))
    }

    internal func decode<T: Decodable>(_ type: T.Type, forKey key: Key) throws -> T {
        codingPath.append(key)

        defer {
            codingPath.removeLast()
        }

        return try decodeComponentValue(try component(forKey: key), as: type)
    }

    internal func nestedContainer<NestedKey: CodingKey>(
        keyedBy keyType: NestedKey.Type,
        forKey key: Key
    ) throws -> KeyedDecodingContainer<NestedKey> {
        try superDecoder(forAnyKey: key).container(keyedBy: keyType)
    }

    internal func nestedUnkeyedContainer(forKey key: Key) throws -> UnkeyedDecodingContainer {
        try superDecoder(forAnyKey: key).unkeyedContainer()
    }

    internal func superDecoder(forKey key: Key) throws -> Decoder {
        try superDecoder(forAnyKey: key)
    }

    internal func superDecoder() throws -> Decoder {
        try superDecoder(forAnyKey: AnyCodingKey.super)
    }
}

private extension DecodingError {

    static func invalidComponent<Key: CodingKey>(
        _ component: Any?,
        forKey key: Key,
        at codingPath: [CodingKey],
        expectation: Any.Type
    ) -> DecodingError {
        switch component {
        case let component?:
            let context = Context(
                codingPath: codingPath,
                debugDescription: "Expected to decode \(expectation) but found \(type(of: component)) instead."
            )

            return .typeMismatch(expectation, context)

        case nil:
            let context = Context(
                codingPath: codingPath,
                debugDescription: "No value associated with key \(key.stringValue)."
            )

            return .keyNotFound(key, context)
        }
    }
}
