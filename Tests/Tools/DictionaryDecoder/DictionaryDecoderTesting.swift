import XCTest

@testable import Nivelir

protocol DictionaryDecoderTesting {

    var decoder: DictionaryDecoder! { get }
}

extension DictionaryDecoderTesting {

    private func makeExpectedValue<T: Decodable>(_ type: T.Type, from dictionary: [String: Any]) throws -> T {
        let jsonDecoder = JSONDecoder()

        jsonDecoder.keyDecodingStrategy = decoder.keyDecodingStrategy.jsonDecodingStrategy
        jsonDecoder.dateDecodingStrategy = decoder.dateDecodingStrategy.jsonDecodingStrategy
        jsonDecoder.dataDecodingStrategy = decoder.dataDecodingStrategy.jsonDecodingStrategy
        jsonDecoder.nonConformingFloatDecodingStrategy = decoder.nonConformingFloatDecodingStrategy.jsonDecodingStrategy

        let data = try JSONSerialization.data(
            withJSONObject: dictionary,
            options: .fragmentsAllowed
        )

        return try jsonDecoder.decode(T.self, from: data)
    }

    func assertDecoderSucceeds<Key: Hashable & Decodable, Value: Decodable & FloatingPoint & Equatable>(
        decoding valueType: [Key: Value].Type,
        from dictionary: [String: Any],
        file: StaticString = #file,
        line: UInt = #line
    ) {
        do {
            let expectedValue = try makeExpectedValue(valueType, from: dictionary)
            let value = try decoder.decode(valueType, from: dictionary)

            XCTAssertEqual(
                NSDictionary(dictionary: value),
                NSDictionary(dictionary: expectedValue),
                file: file,
                line: line
            )
        } catch {
            XCTFail("Test encountered unexpected error: \(error)", file: file, line: line)
        }
    }

    func assertDecoderSucceeds<T: Decodable & Equatable>(
        decoding valueType: T.Type,
        from dictionary: [String: Any],
        file: StaticString = #file,
        line: UInt = #line
    ) {
        do {
            let expectedValue = try makeExpectedValue(valueType, from: dictionary)
            let value = try decoder.decode(valueType, from: dictionary)

            XCTAssertEqual(value, expectedValue, file: file, line: line)
        } catch {
            XCTFail("Test encountered unexpected error: \(error)", file: file, line: line)
        }
    }

    func assertDecoderFails<T: Decodable>(
        decoding valueType: T.Type,
        from dictionary: [String: Any],
        file: StaticString = #file,
        line: UInt = #line,
        errorValidation: (_ error: Error) -> Bool
    ) {
        do {
            _ = try decoder.decode(valueType, from: dictionary)

            XCTFail("Test encountered unexpected behavior", file: file, line: line)
        } catch {
            if !errorValidation(error) {
                XCTFail("Test encountered unexpected error: \(error)", file: file, line: line)
            }
        }
    }
}

extension DictionaryKeyDecodingStrategy {

    fileprivate var jsonDecodingStrategy: JSONDecoder.KeyDecodingStrategy {
        switch self {
        case .useDefaultKeys:
            return .useDefaultKeys

        case let .custom(closure):
            return .custom(closure)
        }
    }
}

extension DictionaryDateDecodingStrategy {

    fileprivate var jsonDecodingStrategy: JSONDecoder.DateDecodingStrategy {
        switch self {
        case .deferredToDate:
            return .deferredToDate

        case .millisecondsSince1970:
            return .millisecondsSince1970

        case .secondsSince1970:
            return .secondsSince1970

        case .iso8601:
            guard #available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *) else {
                fatalError("ISO8601DateFormatter is unavailable on this platform.")
            }

            return .iso8601

        case let .formatted(dateFormatter):
            return .formatted(dateFormatter)

        case let .custom(closure):
            return .custom(closure)
        }
    }
}

extension DictionaryDataDecodingStrategy {

    fileprivate var jsonDecodingStrategy: JSONDecoder.DataDecodingStrategy {
        switch self {
        case .deferredToData:
            return .deferredToData

        case .base64:
            return .base64

        case let .custom(closure):
            return .custom(closure)
        }
    }
}

extension DictionaryNonConformingFloatDecodingStrategy {

    fileprivate var jsonDecodingStrategy: JSONDecoder.NonConformingFloatDecodingStrategy {
        switch self {
        case let .convertFromString(positiveInfinity, negativeInfinity, nan):
            return .convertFromString(
                positiveInfinity: positiveInfinity,
                negativeInfinity: negativeInfinity,
                nan: nan
            )

        case .throw:
            return .throw
        }
    }
}
