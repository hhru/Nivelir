import XCTest

@testable import Nivelir

protocol URLQueryDecoderTesting {

    var decoder: URLQueryDecoder! { get }
}

extension URLQueryDecoderTesting {

    func assertDecoderSucceeds<Key: Hashable & Decodable, Value: Decodable & FloatingPoint & Equatable>(
        decoding valueType: [Key: Value].Type,
        from query: String,
        expecting expectedValue: [Key: Value],
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        do {
            let value = try decoder.decode(valueType, from: query)

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
        from query: String,
        expecting expectedValue: T,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        do {
            let value = try decoder.decode(valueType, from: query)

            XCTAssertEqual(value, expectedValue, file: file, line: line)
        } catch {
            XCTFail("Test encountered unexpected error: \(error)", file: file, line: line)
        }
    }

    func assertDecoderFails<T: Decodable>(
        decoding valueType: T.Type,
        from query: String,
        file: StaticString = #filePath,
        line: UInt = #line,
        errorValidation: (_ error: Error) -> Bool
    ) {
        do {
            _ = try decoder.decode(valueType, from: query)

            XCTFail("Test encountered unexpected behavior", file: file, line: line)
        } catch {
            if !errorValidation(error) {
                XCTFail("Test encountered unexpected error: \(error)", file: file, line: line)
            }
        }
    }
}

extension String {

    internal var urlQueryEncoded: String? {
        var allowedCharacters = CharacterSet.urlQueryAllowed

        allowedCharacters.remove(charactersIn: ":#[]@!$&'()*+,;=")

        return addingPercentEncoding(withAllowedCharacters: allowedCharacters)
    }
}
