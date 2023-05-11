import XCTest

@testable import Nivelir

final class URLQueryDecoderStrategiesTests: XCTestCase, URLQueryDecoderTesting {

    private(set) var decoder: URLQueryDecoder!

    func testThatDecoderSucceedsWhenDecodingStructUsingDefaultKeys() {
        struct DecodableStruct: Decodable, Equatable {
            let foo: Int
            let bar: Int
        }

        decoder.keyDecodingStrategy = .useDefaultKeys

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

    func testThatDecoderSucceedsWhenDecodingStructUsingCustomFunctionForKeys() {
        struct DecodableStruct: Decodable, Equatable {
            let foo: Bool
            let bar: Bool
        }

        decoder.keyDecodingStrategy = .custom { codingPath in
            if let codingKey = codingPath.last?.stringValue.components(separatedBy: ".").first {
                return AnyCodingKey(codingKey)
            }

            return AnyCodingKey("unknown")
        }

        let query = "foo.value=true&bar.value=false"

        let expectedValue = DecodableStruct(
            foo: true,
            bar: false
        )

        assertDecoderSucceeds(
            decoding: DecodableStruct.self,
            from: query,
            expecting: expectedValue
        )
    }

    func testThatDecoderSucceedsWhenDecodingDate() {
        decoder.dateDecodingStrategy = .deferredToDate

        let date = Date(timeIntervalSinceReferenceDate: 123_456.789)
        let query = "foobar=\(date.timeIntervalSinceReferenceDate)"
        let expectedValue = ["foobar": date]

        assertDecoderSucceeds(
            decoding: [String: Date].self,
            from: query,
            expecting: expectedValue
        )
    }

    func testThatDecoderFailsWhenDecodingInvalidDate() {
        decoder.dateDecodingStrategy = .deferredToDate

        let query = "foobar=qwe"

        assertDecoderFails(decoding: [String: Date].self, from: query) { error in
            switch error {
            case let DecodingError.typeMismatch(type, _) where type is Double.Type:
                return true

            default:
                return false
            }
        }
    }

    func testThatDecoderSucceedsWhenDecodingDateFromMillisecondsSince1970() {
        decoder.dateDecodingStrategy = .millisecondsSince1970

        let date = Date(timeIntervalSince1970: 123_456.789)
        let query = "foobar=\(date.timeIntervalSince1970 * 1000)"
        let expectedValue = ["foobar": date]

        assertDecoderSucceeds(
            decoding: [String: Date].self,
            from: query,
            expecting: expectedValue
        )
    }

    func testThatDecoderSucceedsWhenDecodingDateFromSecondsSince1970() {
        decoder.dateDecodingStrategy = .secondsSince1970

        let date = Date(timeIntervalSince1970: 123_456.789)
        let query = "foobar=\(date.timeIntervalSince1970)"
        let expectedValue = ["foobar": date]

        assertDecoderSucceeds(
            decoding: [String: Date].self,
            from: query,
            expecting: expectedValue
        )
    }

    @available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
    func testThatDecoderSucceedsWhenDecodingDateFromISO8601Format() {
        decoder.dateDecodingStrategy = .iso8601

        let dateFormatter = ISO8601DateFormatter()

        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)

        let date = dateFormatter.date(from: "1970-01-02T10:17:36Z")!
        let query = "foobar=\(dateFormatter.string(from: date))"
        let expectedValue = ["foobar": date]

        assertDecoderSucceeds(
            decoding: [String: Date].self,
            from: query,
            expecting: expectedValue
        )
    }

    @available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
    func testThatDecoderFailsWhenDecodingInvalidDateFromISO8601Format() {
        decoder.dateDecodingStrategy = .iso8601

        let query = "foobar=qwe"

        assertDecoderFails(decoding: [String: Date].self, from: query) { error in
            switch error {
            case DecodingError.dataCorrupted:
                return true

            default:
                return false
            }
        }
    }

    func testThatDecoderSucceedsWhenDecodingDateUsingFormatter() {
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)

        decoder.dateDecodingStrategy = .formatted(dateFormatter)

        let date = dateFormatter.date(from: "1970-01-02")!
        let query = "foobar=\(dateFormatter.string(from: date))"
        let expectedValue = ["foobar": date]

        assertDecoderSucceeds(
            decoding: [String: Date].self,
            from: query,
            expecting: expectedValue
        )
    }

    func testThatDecoderFailsWhenDecodingInvalidDateUsingFormatter() {
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)

        decoder.dateDecodingStrategy = .formatted(dateFormatter)

        let query = "foobar=qwe"

        assertDecoderFails(decoding: [String: Date].self, from: query) { error in
            switch error {
            case DecodingError.dataCorrupted:
                return true

            default:
                return false
            }
        }
    }

    func testThatDecoderSucceedsWhenDecodingDateUsingCustomFunction() {
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()

            guard let timeIntervalSince1970 = TimeInterval(try container.decode(String.self)) else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid date")
            }

            return Date(timeIntervalSince1970: timeIntervalSince1970)
        }

        let date = Date(timeIntervalSince1970: 123_456.789)
        let query = "foobar=123456.789"
        let expectedValue = ["foobar": date]

        assertDecoderSucceeds(
            decoding: [String: Date].self,
            from: query,
            expecting: expectedValue
        )
    }

    func testThatDecoderSucceedsWhenDecodingData() {
        decoder.dataDecodingStrategy = .deferredToData

        let query = "foobar[]=1&foobar[]=2&foobar[]=3"
        let expectedValue = ["foobar": Data([1, 2, 3])]

        assertDecoderSucceeds(
            decoding: [String: Data].self,
            from: query,
            expecting: expectedValue
        )
    }

    func testThatDecoderFailsWhenDecodingInvalidData() {
        decoder.dataDecodingStrategy = .deferredToData

        let query = "foobar=qwe"

        assertDecoderFails(decoding: [String: Data].self, from: query) { error in
            switch error {
            case DecodingError.typeMismatch:
                return true

            default:
                return false
            }
        }
    }

    func testThatDecoderSucceedsWhenDecodingDataToBase64() {
        decoder.dataDecodingStrategy = .base64

        let data = Data([1, 2, 3])
        let query = "foobar=\(data.base64EncodedString())"
        let expectedValue = ["foobar": data]

        assertDecoderSucceeds(
            decoding: [String: Data].self,
            from: query,
            expecting: expectedValue
        )
    }

    func testThatDecoderFailsWhenDecodingInvalidDataToBase64() {
        decoder.dataDecodingStrategy = .base64

        let query = "foobar=123"

        assertDecoderFails(decoding: [String: Data].self, from: query) { error in
            switch error {
            case DecodingError.dataCorrupted:
                return true

            default:
                return false
            }
        }
    }

    func testThatDecoderSucceedsWhenDecodingDataUsingCustomFunction() {
        decoder.dataDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let string = try container.decode(String.self)

            let bytes = string
                .components(separatedBy: ",")
                .compactMap { UInt8($0) }

            return Data(bytes)
        }

        let query = "foobar=1,2,3"
        let expectedValue = ["foobar": Data([1, 2, 3])]

        assertDecoderSucceeds(
            decoding: [String: Data].self,
            from: query,
            expecting: expectedValue
        )
    }

    func testThatDecoderFailsWhenDecodingInvalidDataUsingCustomFunction() {
        decoder.dataDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()

            return Data([try container.decode(UInt8.self)])
        }

        let query = "foobar=qwe"

        assertDecoderFails(decoding: [String: Data].self, from: query) { error in
            switch error {
            case let DecodingError.typeMismatch(type, _) where type is UInt8.Type:
                return true

            default:
                return false
            }
        }
    }

    func testThatDecoderFailsWhenDecodingNonConformingFloat() {
        decoder.nonConformingFloatDecodingStrategy = .throw

        let query = "foo=∞&bar=-∞&baz=¬"

        assertDecoderFails(decoding: [String: Float].self, from: query) { error in
            switch error {
            case DecodingError.typeMismatch:
                return true

            default:
                return false
            }
        }
    }

    func testThatDecoderSucceedsWhenDecodingNonConformingFloatFromString() {
        decoder.nonConformingFloatDecodingStrategy = .convertFromString(
            positiveInfinity: "∞",
            negativeInfinity: "-∞",
            nan: "¬"
        )

        let query = "foo=∞&bar=-∞&baz=¬"

        let expectedValue: [String: Float] = [
            "foo": Float.infinity,
            "bar": -Float.infinity,
            "baz": Float.nan
        ]

        assertDecoderSucceeds(
            decoding: [String: Float].self,
            from: query,
            expecting: expectedValue
        )
    }

    func testThatDecoderFailsWhenDecodingNonConformingFloatFromInvalidString() {
        decoder.nonConformingFloatDecodingStrategy = .convertFromString(
            positiveInfinity: "∞",
            negativeInfinity: "-∞",
            nan: "¬"
        )

        let query = "foobar=qwe"

        assertDecoderFails(decoding: [String: Float].self, from: query) { error in
            switch error {
            case let DecodingError.typeMismatch(type, _) where type is Float.Type:
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
