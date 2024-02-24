import XCTest

@testable import Nivelir

final class URLQueryDecoderTests: XCTestCase, URLQueryDecoderTesting {

    private(set) var decoder: URLQueryDecoder!

    func testThatDecoderSucceedsWhenDecodingEmptyURLQuery() {
        let query = ""
        let expectedValue: [String: String] = [:]

        assertDecoderSucceeds(
            decoding: [String: String].self,
            from: query,
            expecting: expectedValue
        )
    }

    func testThatDecoderSucceedsWhenDecodingKeyWithoutValue() {
        let query = "foo&bar=123"

        let expectedValue: [String: Int?] = ["bar": 123]

        assertDecoderSucceeds(
            decoding: [String: Int?].self,
            from: query,
            expecting: expectedValue
        )
    }

    func testThatDecoderSucceedsWhenDecodingStringToBoolDictionary() {
        let query = "foo=true&bar=false"

        let expectedValue = [
            "foo": true,
            "bar": false
        ]

        assertDecoderSucceeds(
            decoding: [String: Bool].self,
            from: query,
            expecting: expectedValue
        )
    }

    func testThatDecoderSucceedsWhenDecodingStringToBoolDictionaryEncodedAsNumericValues() {
        let query = "foo=0&bar=1"

        let expectedValue = [
            "foo": false,
            "bar": true
        ]

        assertDecoderSucceeds(
            decoding: [String: Bool].self,
            from: query,
            expecting: expectedValue
        )
    }

    func testThatDecoderSucceedsWhenDecodingStringToIntDictionary() {
        let query = "foo=123&bar=-456"

        let expectedValue = [
            "foo": 123,
            "bar": -456
        ]

        assertDecoderSucceeds(
            decoding: [String: Int].self,
            from: query,
            expecting: expectedValue
        )
    }

    func testThatDecoderSucceedsWhenDecodingStringToInt8Dictionary() {
        let query = "foo=12&bar=-34"

        let expectedValue: [String: Int8] = [
            "foo": 12,
            "bar": -34
        ]

        assertDecoderSucceeds(
            decoding: [String: Int8].self,
            from: query,
            expecting: expectedValue
        )
    }

    func testThatDecoderSucceedsWhenDecodingStringToInt16Dictionary() {
        let query = "foo=123&bar=-456"

        let expectedValue: [String: Int16] = [
            "foo": 123,
            "bar": -456
        ]

        assertDecoderSucceeds(
            decoding: [String: Int16].self,
            from: query,
            expecting: expectedValue
        )
    }

    func testThatDecoderSucceedsWhenDecodingStringToInt32Dictionary() {
        let query = "foo=123&bar=-456"

        let expectedValue: [String: Int32] = [
            "foo": 123,
            "bar": -456
        ]

        assertDecoderSucceeds(
            decoding: [String: Int32].self,
            from: query,
            expecting: expectedValue
        )
    }

    func testThatDecoderSucceedsWhenDecodingStringToInt64Dictionary() {
        let query = "foo=123&bar=-456"

        let expectedValue: [String: Int64] = [
            "foo": 123,
            "bar": -456
        ]

        assertDecoderSucceeds(
            decoding: [String: Int64].self,
            from: query,
            expecting: expectedValue
        )
    }

    func testThatDecoderSucceedsWhenDecodingStringToUIntDictionary() {
        let query = "foo=123&bar=456"

        let expectedValue: [String: UInt] = [
            "foo": 123,
            "bar": 456
        ]

        assertDecoderSucceeds(
            decoding: [String: UInt].self,
            from: query,
            expecting: expectedValue
        )
    }

    func testThatDecoderSucceedsWhenDecodingStringToUInt8Dictionary() {
        let query = "foo=12&bar=34"

        let expectedValue: [String: UInt8] = [
            "foo": 12,
            "bar": 34
        ]

        assertDecoderSucceeds(
            decoding: [String: UInt8].self,
            from: query,
            expecting: expectedValue
        )
    }

    func testThatDecoderSucceedsWhenDecodingStringToUInt16Dictionary() {
        let query = "foo=123&bar=456"

        let expectedValue: [String: UInt16] = [
            "foo": 123,
            "bar": 456
        ]

        assertDecoderSucceeds(
            decoding: [String: UInt16].self,
            from: query,
            expecting: expectedValue
        )
    }

    func testThatDecoderSucceedsWhenDecodingStringToUInt32Dictionary() {
        let query = "foo=123&bar=456"

        let expectedValue: [String: UInt32] = [
            "foo": 123,
            "bar": 456
        ]

        assertDecoderSucceeds(
            decoding: [String: UInt32].self,
            from: query,
            expecting: expectedValue
        )
    }

    func testThatDecoderSucceedsWhenDecodingStringToUInt64Dictionary() {
        let query = "foo=123&bar=456"

        let expectedValue: [String: UInt64] = [
            "foo": 123,
            "bar": 456
        ]

        assertDecoderSucceeds(
            decoding: [String: UInt64].self,
            from: query,
            expecting: expectedValue
        )
    }

    func testThatDecoderSucceedsWhenDecodingStringToDoubleDictionary() {
        let query = "foo=1.23&bar=-45.6"

        let expectedValue = [
            "foo": 1.23,
            "bar": -45.6
        ]

        assertDecoderSucceeds(
            decoding: [String: Double].self,
            from: query,
            expecting: expectedValue
        )
    }

    func testThatDecoderSucceedsWhenDecodingStringToFloatDictionary() {
        let query = "foo=1.23&bar=-45.6"

        let expectedValue: [String: Float] = [
            "foo": 1.23,
            "bar": -45.6
        ]

        assertDecoderSucceeds(
            decoding: [String: Float].self,
            from: query,
            expecting: expectedValue
        )
    }

    func testThatDecoderSucceedsWhenDecodingStringToStringDictionary() {
        let query = "foo=qwe&bar=asd"

        let expectedValue = [
            "foo": "qwe",
            "bar": "asd"
        ]

        assertDecoderSucceeds(
            decoding: [String: String].self,
            from: query,
            expecting: expectedValue
        )
    }

    func testThatDecoderSucceedsWhenDecodingStringToURLDictionary() {
        let foo = "https://www.swift.org/getting-started#swift-version"
        let bar = "https://getsupport.apple.com/?locale=en_US&caller=sfaq&PRKEYS=PF9"

        let query = "foo=\(foo.urlQueryEncoded!)&bar=\(bar.urlQueryEncoded!)"

        let expectedValue = [
            "foo": URL(string: foo)!,
            "bar": URL(string: bar)!
        ]

        assertDecoderSucceeds(
            decoding: [String: URL].self,
            from: query,
            expecting: expectedValue
        )
    }

    func testThatDecoderSucceedsWhenDecodingStringToArrayDictionary() {
        let query = "foo[]=1&foo[]=2&foo[]=3&bar[0]=4&bar[2]=6"

        let expectedValue: [String: [Int?]] = [
            "foo": [1, 2, 3],
            "bar": [4, nil, 6]
        ]

        assertDecoderSucceeds(
            decoding: [String: [Int?]].self,
            from: query,
            expecting: expectedValue
        )
    }

    func testThatDecoderSucceedsWhenDecodingNestedStringToIntDictionary() {
        let query = "foo[bar]=123&foo[baz]=-456"

        let expectedValue = [
            "foo": [
                "bar": 123,
                "baz": -456
            ]
        ]

        assertDecoderSucceeds(
            decoding: [String: [String: Int]].self,
            from: query,
            expecting: expectedValue
        )
    }

    func testThatDecoderSucceedsWhenDecodingNestedArrayOfStringToIntDictionaries() {
        let query = "foo[0][bar]=123&foo[0][baz]=456"

        let expectedValue = [
            "foo": [
                [
                    "bar": 123,
                    "baz": 456
                ]
            ]
        ]

        assertDecoderSucceeds(
            decoding: [String: [[String: Int]]].self,
            from: query,
            expecting: expectedValue
        )
    }

    func testThatDecoderSucceedsWhenDecodingEmptyStruct() {
        struct DecodableStruct: Decodable, Equatable { }

        let query = ""
        let expectedValue = DecodableStruct()

        assertDecoderSucceeds(
            decoding: DecodableStruct.self,
            from: query,
            expecting: expectedValue
        )
    }

    func testThatDecoderSucceedsWhenDecodingStructWithMultipleProperties() {
        struct DecodableStruct: Decodable, Equatable {
            let foo: Bool
            let bar: Int?
            let baz: Int?
            let bat: String
        }

        let query = "foo=true&bar=123&bat=qwe"

        let expectedValue = DecodableStruct(
            foo: true,
            bar: 123,
            baz: nil,
            bat: "qwe"
        )

        assertDecoderSucceeds(
            decoding: DecodableStruct.self,
            from: query,
            expecting: expectedValue
        )
    }

    func testThatDecoderSucceedsWhenDecodingStructWithNestedStruct() {
        struct DecodableStruct: Decodable, Equatable {
            struct NestedStruct: Decodable, Equatable {
                let bar: Int
                let baz: Int
            }

            let foo: NestedStruct
        }

        let query = "foo[bar]=123&foo[baz]=456"

        let expectedValue = DecodableStruct(
            foo: DecodableStruct.NestedStruct(
                bar: 123,
                baz: 456
            )
        )

        assertDecoderSucceeds(
            decoding: DecodableStruct.self,
            from: query,
            expecting: expectedValue
        )
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

        let query = "foo=qwe&bar=asd"

        let expectedValue = DecodableStruct(
            foo: .qwe,
            bar: .asd
        )

        assertDecoderSucceeds(
            decoding: DecodableStruct.self,
            from: query,
            expecting: expectedValue
        )
    }

    func testThatDecoderSucceedsWhenDecodingStructInSeparateKeyedContainers() {
        struct DecodableStruct: Decodable, Equatable {
            enum CodingKeys: String, CodingKey {
                case foo
                case bar
            }

            let foo: Int
            let bar: Int

            init(foo: Int, bar: Int) {
                self.foo = foo
                self.bar = bar
            }

            init(from decoder: Decoder) throws {
                let barContainer = try decoder.container(keyedBy: CodingKeys.self)
                let bazContainer = try decoder.container(keyedBy: CodingKeys.self)

                foo = try barContainer.decode(Int.self, forKey: .foo)
                bar = try bazContainer.decode(Int.self, forKey: .bar)
            }
        }

        let query = "foo=123&bar=456"

        let expectedValue = DecodableStruct(
            foo: 123,
            bar: 456
        )

        assertDecoderSucceeds(
            decoding: DecodableStruct.self,
            from: query,
            expecting: expectedValue
        )
    }

    func testThatDecoderSucceedsWhenDecodingStructInSeparateUnkeyedContainers() {
        struct DecodableStruct: Decodable, Equatable {
            enum CodingKeys: String, CodingKey {
                case foo
            }

            let bar: Int
            let baz: Int

            init(bar: Int, baz: Int) {
                self.bar = bar
                self.baz = baz
            }

            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)

                var barContainer = try container.nestedUnkeyedContainer(forKey: .foo)
                var bazContainer = try container.nestedUnkeyedContainer(forKey: .foo)

                bar = try barContainer.decode(Int.self)
                baz = try bazContainer.decode(Int.self)
            }
        }

        let query = "foo[]=123&foo[]=456"

        let expectedValue = DecodableStruct(
            bar: 123,
            baz: 123
        )

        assertDecoderSucceeds(
            decoding: DecodableStruct.self,
            from: query,
            expecting: expectedValue
        )
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

            init(bar: Int, baz: Int) {
                self.bar = bar
                self.baz = baz
            }

            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                var unkeyedContainer = try container.nestedUnkeyedContainer(forKey: .foo)

                let barContainer = try unkeyedContainer.nestedContainer(keyedBy: BarCodingKeys.self)
                let bazContainer = try unkeyedContainer.nestedContainer(keyedBy: BazCodingKeys.self)

                bar = try barContainer.decode(Int.self, forKey: .bar)
                baz = try bazContainer.decode(Int.self, forKey: .baz)
            }
        }

        let query = "foo[][bar]=123&foo[][baz]=456"

        let expectedValue = DecodableStruct(
            bar: 123,
            baz: 456
        )

        assertDecoderSucceeds(
            decoding: DecodableStruct.self,
            from: query,
            expecting: expectedValue
        )
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

            init(foo: NestedStruct) {
                self.foo = foo
            }

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

        let query = "foo[bar]=123&foo[baz]=456"

        let expectedValue = DecodableStruct(
            foo: DecodableStruct.NestedStruct(
                bar: 123,
                baz: 456
            )
        )

        assertDecoderSucceeds(
            decoding: DecodableStruct.self,
            from: query,
            expecting: expectedValue
        )
    }

    func testThatDecoderSucceedsWhenDecodingStructUsingSuperDecoder() {
        struct DecodableStruct: Decodable, Equatable {
            enum CodingKeys: String, CodingKey {
                case foo
                case bar
            }

            let foo: String
            let bar: Int

            init(foo: String, bar: Int) {
                self.foo = foo
                self.bar = bar
            }

            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)

                let superDecoder = try container.superDecoder()
                let superContainer = try superDecoder.container(keyedBy: CodingKeys.self)

                foo = try superContainer.decode(String.self, forKey: .foo)
                bar = try container.decode(Int.self, forKey: .bar)
            }
        }

        let query = "super[foo]=qwe&bar=123"

        let expectedValue = DecodableStruct(
            foo: "qwe",
            bar: 123
        )

        assertDecoderSucceeds(
            decoding: DecodableStruct.self,
            from: query,
            expecting: expectedValue
        )
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

            init(foo: String, bar: String, baz: Int) {
                self.foo = foo
                self.bar = bar
                self.baz = baz
            }

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

        let query = "foo[foo]=qwe&bar[bar]=asd&baz=123"

        let expectedValue = DecodableStruct(
            foo: "qwe",
            bar: "asd",
            baz: 123
        )

        assertDecoderSucceeds(
            decoding: DecodableStruct.self,
            from: query,
            expecting: expectedValue
        )
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

            init(foo: String, bar: String, baz: Int, bat: Int) {
                self.foo = foo
                self.bar = bar
                self.baz = baz
                self.bat = bat
            }

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

        let query = "baz[0][]=123&baz[1]=456&baz[2][]=qwe"

        let expectedValue = DecodableStruct(
            foo: "qwe",
            bar: "qwe",
            baz: 456,
            bat: 123
        )

        assertDecoderSucceeds(
            decoding: DecodableStruct.self,
            from: query,
            expecting: expectedValue
        )
    }

    func testThatDecoderSucceedsWhenDecodingSubclass() {
        class DecodableClass: NSObject, Decodable {
            let foo: String

            init(foo: String) {
                self.foo = foo
            }
        }

        class DecodableSubclass: DecodableClass {
            enum CodingKeys: String, CodingKey {
                case bar
                case baz
            }

            let bar: Int
            let baz: Int

            init(foo: String, bar: Int, baz: Int) {
                self.bar = bar
                self.baz = baz

                super.init(foo: foo)
            }

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

        let query = "foo=qwe&bar=123&baz=456"

        let expectedValue = DecodableSubclass(
            foo: "qwe",
            bar: 123,
            baz: 456
        )

        assertDecoderSucceeds(
            decoding: DecodableSubclass.self,
            from: query,
            expecting: expectedValue
        )
    }

    func testThatDecoderFailsWhenDecodingValueWithInvalidKey() {
        let query = "foo[bar=123"

        assertDecoderFails(decoding: [String: [String: Int]].self, from: query) { error in
            switch error {
            case DecodingError.dataCorrupted:
                return true

            default:
                return false
            }
        }
    }

    func testThatDecoderFailsWhenDecodingValuesOfDifferentTypesWithSameKey() {
        let query = "foo=123&foo=qwe"

        assertDecoderFails(decoding: [Int].self, from: query) { error in
            switch error {
            case DecodingError.dataCorrupted:
                return true

            default:
                return false
            }
        }
    }

    func testThatDecoderFailsWhenDecodingArrayWithInvalidKey() {
        let query = "foo[0]=123&foo[qwe]=456"

        assertDecoderFails(decoding: [Int].self, from: query) { error in
            switch error {
            case DecodingError.dataCorrupted:
                return true

            default:
                return false
            }
        }
    }

    func testThatDecoderFailsWhenDecodingArray() {
        let query = "foobar=123"

        assertDecoderFails(decoding: [Int].self, from: query) { error in
            switch error {
            case DecodingError.typeMismatch:
                return true

            default:
                return false
            }
        }
    }

    func testThatDecoderFailsWhenDecodingSingleValue() {
        let query = "foobar=123"

        assertDecoderFails(decoding: Int.self, from: query) { error in
            switch error {
            case DecodingError.typeMismatch:
                return true

            default:
                return false
            }
        }
    }

    func testThatDecoderFailsWhenDecodingInvalidURL() {
        let url = "//invalid url"
        let query = "foobar=\(url.urlQueryEncoded!)"

        assertDecoderFails(decoding: [String: URL].self, from: query) { error in
            switch error {
            case DecodingError.dataCorrupted:
                return true

            default:
                return false
            }
        }
    }

    func testThatDecoderFailsWhenDecodingInvalidStringToBoolDictionary() {
        let query = "foo=qwe&bar=asd"

        assertDecoderFails(decoding: [String: Bool].self, from: query) { error in
            switch error {
            case DecodingError.typeMismatch:
                return true

            default:
                return false
            }
        }
    }

    func testThatDecoderFailsWhenDecodingInvalidStringToIntDictionary() {
        let query = "foo=qwe&bar=asd"

        assertDecoderFails(decoding: [String: Int].self, from: query) { error in
            switch error {
            case DecodingError.typeMismatch:
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

        let query = "foobar=123"

        assertDecoderFails(decoding: DecodableStruct.self, from: query) { error in
            switch error {
            case DecodingError.typeMismatch:
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

        let query = "foo=123"

        assertDecoderFails(decoding: DecodableStruct.self, from: query) { error in
            switch error {
            case DecodingError.typeMismatch:
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

        let query = "foobar=123"

        assertDecoderFails(decoding: DecodableStruct.self, from: query) { error in
            switch error {
            case DecodingError.typeMismatch:
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

        let query = "foo=123"

        assertDecoderFails(decoding: DecodableStruct.self, from: query) { error in
            switch error {
            case DecodingError.typeMismatch:
                return true

            default:
                return false
            }
        }
    }

    override func setUp() {
        super.setUp()

        decoder = URLQueryDecoder()
    }
}
