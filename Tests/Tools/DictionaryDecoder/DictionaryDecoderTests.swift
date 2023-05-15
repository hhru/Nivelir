import XCTest

@testable import Nivelir

final class DictionaryDecoderTests: XCTestCase, DictionaryDecoderTesting {

    private(set) var decoder: DictionaryDecoder!

    func testThatDecoderSucceedsWhenDecodingEmptyDictionary() {
        let dictionary: [String: Any] = [:]

        assertDecoderSucceeds(decoding: [String: String].self, from: dictionary)
    }

    func testThatDecoderSucceedsWhenDecodingStringToBoolDictionary() {
        let dictionary = [
            "foo": true,
            "bar": false
        ]

        assertDecoderSucceeds(decoding: [String: Bool].self, from: dictionary)
    }

    func testThatDecoderSucceedsWhenDecodingStringToIntDictionary() {
        let dictionary = [
            "foo": 123,
            "bar": -456
        ]

        assertDecoderSucceeds(decoding: [String: Int].self, from: dictionary)
    }

    func testThatDecoderSucceedsWhenDecodingStringToInt8Dictionary() {
        let dictionary: [String: Int8] = [
            "foo": 12,
            "bar": -34
        ]

        assertDecoderSucceeds(decoding: [String: Int8].self, from: dictionary)
    }

    func testThatDecoderSucceedsWhenDecodingStringToInt16Dictionary() {
        let dictionary: [String: Int16] = [
            "foo": 123,
            "bar": -456
        ]

        assertDecoderSucceeds(decoding: [String: Int16].self, from: dictionary)
    }

    func testThatDecoderSucceedsWhenDecodingStringToInt32Dictionary() {
        let dictionary: [String: Int32] = [
            "foo": 123,
            "bar": -456
        ]

        assertDecoderSucceeds(decoding: [String: Int32].self, from: dictionary)
    }

    func testThatDecoderSucceedsWhenDecodingStringToInt64Dictionary() {
        let dictionary: [String: Int64] = [
            "foo": 123,
            "bar": -456
        ]

        assertDecoderSucceeds(decoding: [String: Int64].self, from: dictionary)
    }

    func testThatDecoderSucceedsWhenDecodingStringToUIntDictionary() {
        let dictionary: [String: UInt] = [
            "foo": 123,
            "bar": 456
        ]

        assertDecoderSucceeds(decoding: [String: UInt].self, from: dictionary)
    }

    func testThatDecoderSucceedsWhenDecodingStringToUInt8Dictionary() {
        let dictionary: [String: UInt8] = [
            "foo": 12,
            "bar": 45
        ]

        assertDecoderSucceeds(decoding: [String: UInt8].self, from: dictionary)
    }

    func testThatDecoderSucceedsWhenDecodingStringToUInt16Dictionary() {
        let dictionary: [String: UInt16] = [
            "foo": 123,
            "bar": 456
        ]

        assertDecoderSucceeds(decoding: [String: UInt16].self, from: dictionary)
    }

    func testThatDecoderSucceedsWhenDecodingStringToUInt32Dictionary() {
        let dictionary: [String: UInt32] = [
            "foo": 123,
            "bar": 456
        ]

        assertDecoderSucceeds(decoding: [String: UInt32].self, from: dictionary)
    }

    func testThatDecoderSucceedsWhenDecodingStringToUInt64Dictionary() {
        let dictionary: [String: UInt64] = [
            "foo": 123,
            "bar": 456
        ]

        assertDecoderSucceeds(decoding: [String: UInt64].self, from: dictionary)
    }

    func testThatDecoderSucceedsWhenDecodingStringToDoubleDictionary() {
        let dictionary = [
            "foo": 1.23,
            "bar": -45.6
        ]

        assertDecoderSucceeds(decoding: [String: Double].self, from: dictionary)
    }

    func testThatDecoderSucceedsWhenDecodingStringToFloatDictionary() {
        let dictionary: [String: Float] = [
            "foo": 1.23,
            "bar": -45.6
        ]

        assertDecoderSucceeds(decoding: [String: Float].self, from: dictionary)
    }

    func testThatDecoderSucceedsWhenDecodingStringToStringDictionary() {
        let dictionary = [
            "foo": "qwe",
            "bar": "asd"
        ]

        assertDecoderSucceeds(decoding: [String: String].self, from: dictionary)
    }

    func testThatDecoderSucceedsWhenDecodingStringToURLDictionary() {
        let dictionary = [
            "foo": "https://swift.org",
            "bar": "https://apple.com"
        ]

        assertDecoderSucceeds(decoding: [String: URL].self, from: dictionary)
    }

    func testThatDecoderSucceedsWhenDecodingStringToArrayDictionary() {
        let dictionary: [String: [Int?]] = [
            "foo": [1, 2, 3],
            "bar": [4, nil, 6]
        ]

        assertDecoderSucceeds(decoding: [String: [Int?]].self, from: dictionary)
    }

    func testThatDecoderSucceedsWhenDecodingNestedStringToIntDictionary() {
        let dictionary = [
            "foo": [
                "bar": 123,
                "baz": -456
            ]
        ]

        assertDecoderSucceeds(decoding: [String: [String: Int]].self, from: dictionary)
    }

    func testThatDecoderSucceedsWhenDecodingNestedArrayOfStringToIntDictionaries() {
        let dictionary = [
            "foo": [
                [
                    "bar": 123,
                    "baz": 456
                ]
            ]
        ]

        assertDecoderSucceeds(decoding: [String: [[String: Int]]].self, from: dictionary)
    }

    func testThatDecoderSucceedsWhenDecodingEmptyStruct() {
        struct DecodableStruct: Decodable, Equatable { }

        let dictionary: [String: Any] = [:]

        assertDecoderSucceeds(decoding: DecodableStruct.self, from: dictionary)
    }

    func testThatDecoderSucceedsWhenDecodingStructWithNSNull() {
        struct DecodableStruct: Decodable, Equatable {
            let foo: Bool
            let bar: Int?
        }

        let dictionary: [String: Any] = [
            "foo": true,
            "bar": NSNull()
        ]

        assertDecoderSucceeds(decoding: DecodableStruct.self, from: dictionary)
    }

    func testThatDecoderSucceedsWhenDecodingStructWithMultipleProperties() {
        struct DecodableStruct: Decodable, Equatable {
            let foo: Bool
            let bar: Int?
            let baz: Int?
            let bat: String
        }

        let dictionary: [String: Any] = [
            "foo": true,
            "bar": 123,
            "bat": "qwe"
        ]

        assertDecoderSucceeds(decoding: DecodableStruct.self, from: dictionary)
    }

    func testThatDecoderSucceedsWhenDecodingStructWithNestedStruct() {
        struct DecodableStruct: Decodable, Equatable {
            struct NestedStruct: Decodable, Equatable {
                let bar: Int
                let baz: Int
            }

            let foo: NestedStruct
        }

        let dictionary = [
            "foo": [
                "bar": 123,
                "baz": 456
            ]
        ]

        assertDecoderSucceeds(decoding: DecodableStruct.self, from: dictionary)
    }

    func testThatDecoderSucceedsWhenDecodingStructWithNestedEnum() {
        struct DecodableStruct: Decodable, Equatable {
            enum NestedEnum: String, Decodable {
                case qwe
                case asd
            }

            let foo: NestedEnum
            let bar: NestedEnum
        }

        let dictionary = [
            "foo": "qwe",
            "bar": "asd"
        ]

        assertDecoderSucceeds(decoding: DecodableStruct.self, from: dictionary)
    }

    func testThatDecoderSucceedsWhenDecodingStructInSeparateKeyedContainers() {
        struct DecodableStruct: Decodable, Equatable {
            enum CodingKeys: String, CodingKey {
                case foo
                case bar
            }

            let foo: Int
            let bar: Int

            init(from decoder: Decoder) throws {
                let barContainer = try decoder.container(keyedBy: CodingKeys.self)
                let bazContainer = try decoder.container(keyedBy: CodingKeys.self)

                foo = try barContainer.decode(Int.self, forKey: .foo)
                bar = try bazContainer.decode(Int.self, forKey: .bar)
            }
        }

        let dictionary = [
            "foo": 123,
            "bar": 456
        ]

        assertDecoderSucceeds(decoding: DecodableStruct.self, from: dictionary)
    }

    func testThatDecoderSucceedsWhenDecodingStructInSeparateUnkeyedContainers() {
        struct DecodableStruct: Decodable, Equatable {
            enum CodingKeys: String, CodingKey {
                case foo
            }

            let bar: Int
            let baz: Int

            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)

                var barContainer = try container.nestedUnkeyedContainer(forKey: .foo)
                var bazContainer = try container.nestedUnkeyedContainer(forKey: .foo)

                bar = try barContainer.decode(Int.self)
                baz = try bazContainer.decode(Int.self)
            }
        }

        let dictionary = ["foo": [123, 456]]

        assertDecoderSucceeds(decoding: DecodableStruct.self, from: dictionary)
    }

    func testThatDecoderSucceedsWhenDecodingStructInSeparateKeyedContainersOfUnkeyedContainer() {
        struct DecodableStruct: Decodable, Equatable {
            enum CodingKeys: String, CodingKey {
                case foo
            }

            enum BarCodingKeys: String, CodingKey {
                case bar
            }

            enum BazCodingKeys: String, CodingKey {
                case baz
            }

            let bar: Int
            let baz: Int

            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                var unkeyedContainer = try container.nestedUnkeyedContainer(forKey: .foo)

                let barContainer = try unkeyedContainer.nestedContainer(keyedBy: BarCodingKeys.self)
                let bazContainer = try unkeyedContainer.nestedContainer(keyedBy: BazCodingKeys.self)

                bar = try barContainer.decode(Int.self, forKey: .bar)
                baz = try bazContainer.decode(Int.self, forKey: .baz)
            }
        }

        let dictionary = [
            "foo": [
                ["bar": 123],
                ["baz": 456]
            ]
        ]

        assertDecoderSucceeds(decoding: DecodableStruct.self, from: dictionary)
    }

    func testThatDecoderSucceedsWhenDecodingStructInSeparateNestedKeyedContainers() {
        struct DecodableStruct: Decodable, Equatable {
            enum CodingKeys: String, CodingKey {
                case foo
            }

            struct NestedStruct: Equatable {
                enum CodingKeys: String, CodingKey {
                    case bar
                    case baz
                }

                let bar: Int
                let baz: Int
            }

            let foo: NestedStruct

            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)

                let barContainer = try container.nestedContainer(keyedBy: NestedStruct.CodingKeys.self, forKey: .foo)
                let bazContainer = try container.nestedContainer(keyedBy: NestedStruct.CodingKeys.self, forKey: .foo)

                foo = NestedStruct(
                    bar: try barContainer.decode(Int.self, forKey: .bar),
                    baz: try bazContainer.decode(Int.self, forKey: .baz)
                )
            }
        }

        let dictionary = [
            "foo": [
                "bar": 123,
                "baz": 456
            ]
        ]

        assertDecoderSucceeds(decoding: DecodableStruct.self, from: dictionary)
    }

    func testThatDecoderSucceedsWhenDecodingStructUsingSuperDecoder() {
        struct DecodableStruct: Decodable, Equatable {
            enum CodingKeys: String, CodingKey {
                case foo
                case bar
            }

            let foo: String
            let bar: Int

            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)

                let superDecoder = try container.superDecoder()
                let superContainer = try superDecoder.container(keyedBy: CodingKeys.self)

                foo = try superContainer.decode(String.self, forKey: .foo)
                bar = try container.decode(Int.self, forKey: .bar)
            }
        }

        let dictionary: [String: Any] = [
            "super": ["foo": "qwe"],
            "bar": 123
        ]

        assertDecoderSucceeds(decoding: DecodableStruct.self, from: dictionary)
    }

    func testThatDecoderSucceedsWhenDecodingStructUsingSuperDecoderForKeys() {
        struct DecodableStruct: Decodable, Equatable {
            enum CodingKeys: String, CodingKey {
                case foo
                case bar
                case baz
            }

            let foo: String
            let bar: String
            let baz: Int

            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)

                let fooSuperDecoder = try container.superDecoder(forKey: .foo)
                let barSuperDecoder = try container.superDecoder(forKey: .bar)

                let fooContainer = try fooSuperDecoder.container(keyedBy: CodingKeys.self)
                let barContainer = try barSuperDecoder.container(keyedBy: CodingKeys.self)

                foo = try fooContainer.decode(String.self, forKey: .foo)
                bar = try barContainer.decode(String.self, forKey: .bar)
                baz = try container.decode(Int.self, forKey: .baz)
            }
        }

        let dictionary: [String: Any] = [
            "foo": ["foo": "qwe"],
            "bar": ["bar": "asd"],
            "baz": 123
        ]

        assertDecoderSucceeds(decoding: DecodableStruct.self, from: dictionary)
    }

    func testThatDecoderSucceedsWhenDecodingStructUsingSuperDecoderOfNestedUnkeyedContainer() {
        struct DecodableStruct: Decodable, Equatable {
            enum CodingKeys: String, CodingKey {
                case baz
            }

            let foo: String
            let bar: String
            let baz: Int
            let bat: Int

            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)

                var bazContainer = try container.nestedUnkeyedContainer(forKey: .baz)
                var batContainer = try bazContainer.nestedUnkeyedContainer()

                baz = try bazContainer.decode(Int.self)
                bat = try batContainer.decode(Int.self)

                let bazSuperDecoder = try bazContainer.superDecoder()

                var fooContainer = try bazSuperDecoder.unkeyedContainer()
                var barContainer = try bazSuperDecoder.unkeyedContainer()

                foo = try fooContainer.decode(String.self)
                bar = try barContainer.decode(String.self)
            }
        }

        let dictionary = ["baz": [[123], 345, ["qwe"]] as [Any]]

        assertDecoderSucceeds(decoding: DecodableStruct.self, from: dictionary)
    }

    func testThatDecoderSucceedsWhenDecodingSubclass() {
        class DecodableClass: NSObject, Decodable {
            let foo: String
        }

        class DecodableSubclass: DecodableClass {
            enum CodingKeys: String, CodingKey {
                case bar
                case baz
            }

            let bar: Int
            let baz: Int

            required init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)

                bar = try container.decode(Int.self, forKey: .bar)
                baz = try container.decode(Int.self, forKey: .baz)

                try super.init(from: decoder)
            }

            override func isEqual(_ object: Any?) -> Bool {
                guard let object = object as? Self else {
                    return false
                }

                return foo == object.foo
                    && bar == object.bar
                    && baz == object.baz
            }
        }

        let dictionary: [String: Any] = [
            "foo": "qwe",
            "bar": 123,
            "baz": 456
        ]

        assertDecoderSucceeds(decoding: DecodableSubclass.self, from: dictionary)
    }

    func testThatDecoderFailsWhenDecodingArray() {
        let dictionary = ["foobar": 123]

        assertDecoderFails(decoding: [Int].self, from: dictionary) { error in
            switch error {
            case let DecodingError.typeMismatch(type, _) where type is [Any].Type:
                return true

            default:
                return false
            }
        }
    }

    func testThatDecoderFailsWhenDecodingSingleValue() {
        let dictionary = ["foobar": 123]

        assertDecoderFails(decoding: Int.self, from: dictionary) { error in
            switch error {
            case let DecodingError.typeMismatch(type, _) where type is Int.Type:
                return true

            default:
                return false
            }
        }
    }

    func testThatDecoderFailsWhenDecodingInvalidURL() {
        let dictionary = ["foobar": "invalid url"]

        assertDecoderFails(decoding: [String: URL].self, from: dictionary) { error in
            switch error {
            case DecodingError.dataCorrupted:
                return true

            default:
                return false
            }
        }
    }

    func testThatDecoderFailsWhenDecodingNilForKeyedContainer() {
        struct DecodableStruct: Decodable {
            enum CodingKeys: String, CodingKey {
                case foo
                case bar
            }

            let foo: Int
            let bar: Int

            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)

                let superDecoder = try container.superDecoder(forKey: .foo)
                let superContainer = try superDecoder.container(keyedBy: CodingKeys.self)

                foo = try superContainer.decode(Int.self, forKey: .foo)
                bar = try superContainer.decode(Int.self, forKey: .bar)
            }
        }

        let dictionary = ["foobar": 123]

        assertDecoderFails(decoding: DecodableStruct.self, from: dictionary) { error in
            switch error {
            case let DecodingError.typeMismatch(type, _) where type is [String: Any].Type:
                return true

            default:
                return false
            }
        }
    }

    func testThatDecoderFailsWhenDecodingInvalidForKeyedContainer() {
        struct DecodableStruct: Decodable {
            enum CodingKeys: String, CodingKey {
                case foo
                case bar
            }

            let foo: Int
            let bar: Int

            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)

                let superDecoder = try container.superDecoder(forKey: .foo)
                let superContainer = try superDecoder.container(keyedBy: CodingKeys.self)

                foo = try superContainer.decode(Int.self, forKey: .foo)
                bar = try superContainer.decode(Int.self, forKey: .bar)
            }
        }

        let dictionary = ["foo": 123]

        assertDecoderFails(decoding: DecodableStruct.self, from: dictionary) { error in
            switch error {
            case let DecodingError.typeMismatch(type, _) where type is [String: Any].Type:
                return true

            default:
                return false
            }
        }
    }

    func testThatDecoderFailsWhenDecodingNilForUnkeyedContainer() {
        struct DecodableStruct: Decodable {
            enum CodingKeys: String, CodingKey {
                case foo
            }

            let foo: Int
            let bar: Int

            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)

                let superDecoder = try container.superDecoder(forKey: .foo)
                var superContainer = try superDecoder.unkeyedContainer()

                foo = try superContainer.decode(Int.self)
                bar = try superContainer.decode(Int.self)
            }
        }

        let dictionary = ["foobar": 123]

        assertDecoderFails(decoding: DecodableStruct.self, from: dictionary) { error in
            switch error {
            case let DecodingError.typeMismatch(type, _) where type is [Any].Type:
                return true

            default:
                return false
            }
        }
    }

    func testThatDecoderFailsWhenDecodingInvalidForUnkeyedContainer() {
        struct DecodableStruct: Decodable {
            enum CodingKeys: String, CodingKey {
                case foo
                case bar
            }

            let foo: Int
            let bar: Int

            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)

                let superDecoder = try container.superDecoder(forKey: .foo)
                var superContainer = try superDecoder.unkeyedContainer()

                foo = try superContainer.decode(Int.self)
                bar = try superContainer.decode(Int.self)
            }
        }

        let dictionary = ["foo": 123]

        assertDecoderFails(decoding: DecodableStruct.self, from: dictionary) { error in
            switch error {
            case let DecodingError.typeMismatch(type, _) where type is [Any].Type:
                return true

            default:
                return false
            }
        }
    }

    override func setUp() {
        super.setUp()

        decoder = DictionaryDecoder()
    }
}
