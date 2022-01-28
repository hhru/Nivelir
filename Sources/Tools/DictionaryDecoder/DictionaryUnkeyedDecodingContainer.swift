import Foundation

internal final class DictionaryUnkeyedDecodingContainer: DictionaryComponentDecoder {

    internal let components: [Any?]
    internal let options: DictionaryDecodingOptions
    internal let userInfo: [CodingUserInfoKey: Any]
    internal let codingPath: [CodingKey]

    internal private(set) var currentIndex = 0

    internal var currentCodingPath: [CodingKey] {
        codingPath.appending(AnyCodingKey(currentIndex))
    }

    internal init(
        components: [Any?],
        options: DictionaryDecodingOptions,
        userInfo: [CodingUserInfoKey: Any],
        codingPath: [CodingKey]
    ) {
        self.components = components
        self.options = options
        self.userInfo = userInfo
        self.codingPath = codingPath
    }

    private func popNextComponent() throws -> Any? {
        guard currentIndex < components.count else {
            let errorContext = DecodingError.Context(
                codingPath: currentCodingPath,
                debugDescription: "Unkeyed container is at end."
            )

            throw DecodingError.valueNotFound(Any.self, errorContext)
        }

        defer {
            currentIndex += 1
        }

        return components[currentIndex]
    }
}

extension DictionaryUnkeyedDecodingContainer: UnkeyedDecodingContainer {

    internal var count: Int? {
        components.count
    }

    internal var isAtEnd: Bool {
        currentIndex == count
    }

    internal func decodeNil() throws -> Bool {
        decodeNilComponent(from: try popNextComponent())
    }

    internal func decode(_ type: Bool.Type) throws -> Bool {
        try decodeComponentValue(from: try popNextComponent(), at: currentCodingPath)
    }

    internal func decode(_ type: Int.Type) throws -> Int {
        try decodeComponentValue(from: try popNextComponent(), at: currentCodingPath)
    }

    internal func decode(_ type: Int8.Type) throws -> Int8 {
        try decodeComponentValue(from: try popNextComponent(), at: currentCodingPath)
    }

    internal func decode(_ type: Int16.Type) throws -> Int16 {
        try decodeComponentValue(from: try popNextComponent(), at: currentCodingPath)
    }

    internal func decode(_ type: Int32.Type) throws -> Int32 {
        try decodeComponentValue(from: try popNextComponent(), at: currentCodingPath)
    }

    internal func decode(_ type: Int64.Type) throws -> Int64 {
        try decodeComponentValue(from: try popNextComponent(), at: currentCodingPath)
    }

    internal func decode(_ type: UInt.Type) throws -> UInt {
        try decodeComponentValue(from: try popNextComponent(), at: currentCodingPath)
    }

    internal func decode(_ type: UInt8.Type) throws -> UInt8 {
        try decodeComponentValue(from: try popNextComponent(), at: currentCodingPath)
    }

    internal func decode(_ type: UInt16.Type) throws -> UInt16 {
        try decodeComponentValue(from: try popNextComponent(), at: currentCodingPath)
    }

    internal func decode(_ type: UInt32.Type) throws -> UInt32 {
        try decodeComponentValue(from: try popNextComponent(), at: currentCodingPath)
    }

    internal func decode(_ type: UInt64.Type) throws -> UInt64 {
        try decodeComponentValue(from: try popNextComponent(), at: currentCodingPath)
    }

    internal func decode(_ type: Double.Type) throws -> Double {
        try decodeComponentValue(from: try popNextComponent(), at: currentCodingPath)
    }

    internal func decode(_ type: Float.Type) throws -> Float {
        try decodeComponentValue(from: try popNextComponent(), at: currentCodingPath)
    }

    internal func decode(_ type: String.Type) throws -> String {
        try decodeComponentValue(from: try popNextComponent(), at: currentCodingPath)
    }

    internal func decode<T: Decodable>(_ type: T.Type) throws -> T {
        try decodeComponentValue(of: type, from: try popNextComponent(), at: currentCodingPath)
    }

    internal func nestedContainer<NestedKey: CodingKey>(
        keyedBy keyType: NestedKey.Type
    ) throws -> KeyedDecodingContainer<NestedKey> {
        try superDecoder().container(keyedBy: keyType)
    }

    internal func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
        try superDecoder().unkeyedContainer()
    }

    internal func superDecoder() throws -> Decoder {
        DictionarySingleValueDecodingContainer(
            component: try popNextComponent(),
            options: options,
            userInfo: userInfo,
            codingPath: currentCodingPath
        )
    }
}
