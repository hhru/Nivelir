import Foundation

public enum ScreenKey: Equatable, CustomStringConvertible {

    case `default`(name: String)
    case custom(ScreenCustomKey)

    public var description: String {
        switch self {
        case let .default(name):
            return name

        case let .custom(key):
            return key.description
        }
    }
}

extension ScreenKey {

    public static func `default`(type: Any.Type) -> Self {
        .default(name: "\(type)")
    }

    public static func == (lhs: ScreenKey, rhs: ScreenKey) -> Bool {
        switch (lhs, rhs) {
        case (.default, .default):
            return true

        case let (.custom(lhs), .custom(rhs)):
            return lhs.isEqual(to: rhs)

        case (.default, .custom), (.custom, .default):
            return false
        }
    }
}
