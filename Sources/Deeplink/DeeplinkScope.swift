import Foundation

public struct DeeplinkScope: Hashable, ExpressibleByStringLiteral {

    public let key: String?

    private init() {
        self.key = nil
    }

    public init(key: String) {
        self.key = key
    }

    public init(stringLiteral key: String) {
        self.init(key: key)
    }
}

extension DeeplinkScope {

    public static let `default` = Self()

    public static func fromPropertyName(_ name: String = #function) -> Self {
        Self(key: name)
    }
}
