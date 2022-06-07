import Foundation

public struct DeeplinkScope: Hashable, ExpressibleByStringLiteral {

    public let key: String?

    private init() {
        self.key = nil
    }

    public init(key: String = #function) {
        self.key = key
    }

    public init(stringLiteral key: String) {
        self.init(key: key)
    }
}

extension DeeplinkScope {

    public static let `default` = Self()
}
