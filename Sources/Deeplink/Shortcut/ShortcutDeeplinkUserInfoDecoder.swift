#if canImport(UIKit) && os(iOS)
import Foundation

public protocol ShortcutDeeplinkUserInfoDecoder {

    func decode<T: Decodable>(
        _ type: T.Type,
        from dictionary: [String: NSSecureCoding]
    ) throws -> T
}

extension DictionaryDecoder: ShortcutDeeplinkUserInfoDecoder {

    internal func decode<T: Decodable>(
        _ type: T.Type,
        from dictionary: [String: NSSecureCoding]
    ) throws -> T {
        try decode(
            T.self,
            from: dictionary as [String: Any]
        )
    }
}
#endif
