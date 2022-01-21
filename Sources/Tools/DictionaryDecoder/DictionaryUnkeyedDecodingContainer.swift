import Foundation

internal final class DictionaryUnkeyedDecodingContainer: DictionaryComponentDecoder {

    internal let components: [Any?]
    internal let options: DictionaryDecodingOptions
    internal let userInfo: [CodingUserInfoKey: Any]
    internal let codingPath: [CodingKey]

    internal private(set) var currentIndex = 0

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

    private func popNextComponent<T>(of type: T.Type = T.self) throws -> T {
        guard currentIndex < components.count else {
            let errorContext = DecodingError.Context(
                codingPath: codingPath.appending(AnyCodingKey(currentIndex)),
                debugDescription: "Unkeyed container is at end."
            )

            throw DecodingError.valueNotFound(type, errorContext)
        }

        let anyComponent = components[currentIndex]

        guard let component = anyComponent as? T else {
            throw DecodingError.invalidComponent(
                anyComponent,
                at: codingPath.appending(AnyCodingKey(currentIndex)),
                expectation: type
            )
        }

        currentIndex += 1

        return component
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
        decodeNilComponent(try popNextComponent())
    }

    internal func decode(_ type: Bool.Type) throws -> Bool {
        try decodeComponentValue(try popNextComponent())
    }

    internal func decode(_ type: Int.Type) throws -> Int {
        try decodeComponentValue(try popNextComponent())
    }

    internal func decode(_ type: Int8.Type) throws -> Int8 {
        try decodeComponentValue(try popNextComponent())
    }

    internal func decode(_ type: Int16.Type) throws -> Int16 {
        try decodeComponentValue(try popNextComponent())
    }

    internal func decode(_ type: Int32.Type) throws -> Int32 {
        try decodeComponentValue(try popNextComponent())
    }

    internal func decode(_ type: Int64.Type) throws -> Int64 {
        try decodeComponentValue(try popNextComponent())
    }

    internal func decode(_ type: UInt.Type) throws -> UInt {
        try decodeComponentValue(try popNextComponent())
    }

    internal func decode(_ type: UInt8.Type) throws -> UInt8 {
        try decodeComponentValue(try popNextComponent())
    }

    internal func decode(_ type: UInt16.Type) throws -> UInt16 {
        try decodeComponentValue(try popNextComponent())
    }

    internal func decode(_ type: UInt32.Type) throws -> UInt32 {
        try decodeComponentValue(try popNextComponent())
    }

    internal func decode(_ type: UInt64.Type) throws -> UInt64 {
        try decodeComponentValue(try popNextComponent())
    }

    internal func decode(_ type: Double.Type) throws -> Double {
        try decodeComponentValue(try popNextComponent())
    }

    internal func decode(_ type: Float.Type) throws -> Float {
        try decodeComponentValue(try popNextComponent())
    }

    internal func decode(_ type: String.Type) throws -> String {
        try decodeComponentValue(try popNextComponent())
    }

    internal func decode<T: Decodable>(_ type: T.Type) throws -> T {
        try decodeComponentValue(try popNextComponent(), as: type)
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
            codingPath: codingPath.appending(AnyCodingKey(currentIndex))
        )
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
