import XCTest

@testable import Nivelir

final class DictionaryDecoderStrategiesTests: XCTestCase, DictionaryDecoderTesting {

    private(set) var decoder: DictionaryDecoder!

    func testThatDecoderSucceedsWhenDecodingStructUsingDefaultKeys() {
        struct DecodableStruct: Decodable, Equatable {
            let foo: Int
            let bar: Int
        }

        decoder.keyDecodingStrategy = .useDefaultKeys

        let dictionary = [
            "foo": 123,
            "bar": 456
        ]

        assertDecoderSucceeds(decoding: DecodableStruct.self, from: dictionary)
    }

    func testThatDecoderSucceedsWhenDecodingStructUsingCustomFunctionForKeys() {
        struct DecodableStruct: Decodable, Equatable {
            let foo: Bool
            let bar: Bool
        }

        decoder.keyDecodingStrategy = .custom { codingPath in
            if let codingKey = codingPath.last?.stringValue.components(separatedBy: ".").first {
                return AnyCodingKey(codingKey)
            } else {
                return AnyCodingKey("unknown")
            }
        }

        let dictionary = [
            "foo.value": true,
            "bar.value": false
        ]

        assertDecoderSucceeds(decoding: DecodableStruct.self, from: dictionary)
    }

    func testThatDecoderSucceedsWhenDecodingDate() {
        decoder.dateDecodingStrategy = .deferredToDate

        let dictionary = ["foobar": 123_456.789]

        assertDecoderSucceeds(decoding: [String: Date].self, from: dictionary)
    }

    func testThatDecoderFailsWhenDecodingInvalidDate() {
        decoder.dateDecodingStrategy = .deferredToDate

        let dictionary = ["foobar": "qwe"]

        assertDecoderFails(decoding: [String: Date].self, from: dictionary) { error in
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

        let dictionary = ["foobar": 123_456.789]

        assertDecoderSucceeds(decoding: [String: Date].self, from: dictionary)
    }

    func testThatDecoderSucceedsWhenDecodingDateFromSecondsSince1970() {
        decoder.dateDecodingStrategy = .secondsSince1970

        let dictionary = ["foobar": 123_456.789]

        assertDecoderSucceeds(decoding: [String: Date].self, from: dictionary)
    }

    @available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
    func testThatDecoderSucceedsWhenDecodingDateFromISO8601Format() {
        decoder.dateDecodingStrategy = .iso8601

        let dictionary = ["foobar": "2001-01-01T00:02:03Z"]

        assertDecoderSucceeds(decoding: [String: Date].self, from: dictionary)
    }

    @available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
    func testThatDecoderFailsWhenDecodingInvalidDateFromISO8601Format() {
        decoder.dateDecodingStrategy = .iso8601

        let dictionary = ["foobar": "qwe"]

        assertDecoderFails(decoding: [String: Date].self, from: dictionary) { error in
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

        let dictionary = ["foobar": "2001-01-02"]

        assertDecoderSucceeds(decoding: [String: Date].self, from: dictionary)
    }

    func testThatDecoderFailsWhenDecodingInvalidDateUsingFormatter() {
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)

        decoder.dateDecodingStrategy = .formatted(dateFormatter)

        let dictionary = ["foobar": "qwe"]

        assertDecoderFails(decoding: [String: Date].self, from: dictionary) { error in
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

        let dictionary = ["foobar": "123456.789"]

        assertDecoderSucceeds(decoding: [String: Date].self, from: dictionary)
    }

    func testThatDecoderSucceedsWhenDecodingData() {
        decoder.dataDecodingStrategy = .deferredToData

        let dictionary: [String: [UInt8]] = ["foobar": [1, 2, 3]]

        assertDecoderSucceeds(decoding: [String: Data].self, from: dictionary)
    }

    func testThatDecoderFailsWhenDecodingInvalidData() {
        decoder.dataDecodingStrategy = .deferredToData

        let dictionary = ["foobar": "qwe"]

        assertDecoderFails(decoding: [String: Data].self, from: dictionary) { error in
            switch error {
            case let DecodingError.typeMismatch(type, _) where type is [Any].Type:
                return true

            default:
                return false
            }
        }
    }

    func testThatDecoderSucceedsWhenDecodingDataToBase64() {
        decoder.dataDecodingStrategy = .base64

        let dictionary = ["foobar": "AQID"]

        assertDecoderSucceeds(decoding: [String: Data].self, from: dictionary)
    }

    func testThatDecoderFailsWhenDecodingInvalidDataToBase64() {
        decoder.dataDecodingStrategy = .base64

        let dictionary = ["foobar": "123"]

        assertDecoderFails(decoding: [String: Data].self, from: dictionary) { error in
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
                .components(separatedBy: ", ")
                .compactMap { UInt8($0) }

            return Data(bytes)
        }

        let dictionary = ["foobar": "1, 2, 3"]

        assertDecoderSucceeds(decoding: [String: Data].self, from: dictionary)
    }

    func testThatDecoderFailsWhenDecodingInvalidDataUsingCustomFunction() {
        decoder.dataDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let string = try container.decode(String.self)

            let bytes = string
                .components(separatedBy: ", ")
                .compactMap { UInt8($0) }

            return Data(bytes)
        }

        let dictionary = ["foobar": 123]

        assertDecoderFails(decoding: [String: Data].self, from: dictionary) { error in
            switch error {
            case let DecodingError.typeMismatch(type, _) where type is String.Type:
                return true

            default:
                return false
            }
        }
    }

    func testThatDecoderFailsWhenDecodingNonConformingFloat() {
        decoder.nonConformingFloatDecodingStrategy = .throw

        let dictionary = [
            "foo": Float.infinity,
            "bar": -Float.infinity,
            "baz": Float.nan
        ]

        assertDecoderFails(decoding: [String: Float].self, from: dictionary) { error in
            switch error {
            case DecodingError.dataCorrupted:
                return true

            default:
                return false
            }
        }
    }

    func testThatDecoderSucceedsWhenDecodingNonConformingFloatFromString() {
        decoder.nonConformingFloatDecodingStrategy = .convertFromString(
            positiveInfinity: "+∞",
            negativeInfinity: "-∞",
            nan: "¬"
        )

        let dictionary = [
            "foo": "+∞",
            "bar": "-∞",
            "baz": "¬"
        ]

        assertDecoderSucceeds(decoding: [String: Float].self, from: dictionary)
    }

    func testThatDecoderFailsWhenDecodingNonConformingFloatFromInvalidString() {
        decoder.nonConformingFloatDecodingStrategy = .convertFromString(
            positiveInfinity: "+∞",
            negativeInfinity: "-∞",
            nan: "¬"
        )

        let dictionary = ["foobar": "qwe"]

        assertDecoderFails(decoding: [String: Float].self, from: dictionary) { error in
            switch error {
            case let DecodingError.typeMismatch(type, _) where type is Float.Type:
                return true

            default:
                return false
            }
        }
    }

    func testThatDecoderFailsWhenDecodingFloatFromWrongType() {
        let dictionary = ["foobar": true]

        assertDecoderFails(decoding: [String: Float].self, from: dictionary) { error in
            switch error {
            case let DecodingError.typeMismatch(type, _) where type is Float.Type:
                return true

            default:
                return false
            }
        }
    }

    func testThatDecoderFailsWhenDecodingFloatFromNil() {
        let dictionary: [String: [Float?]] = ["foobar": [1.23, nil]]

        assertDecoderFails(decoding: [String: [Float]].self, from: dictionary) { error in
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

        decoder = DictionaryDecoder()
    }
}
