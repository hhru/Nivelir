#if os(iOS)
import Foundation

public protocol NotificationDeeplinkUserInfoDecoder {

    func decode<T: Decodable>(_ type: T.Type, from dictionary: [String: Any]) throws -> T
}

extension DictionaryDecoder: NotificationDeeplinkUserInfoDecoder { }
#endif
