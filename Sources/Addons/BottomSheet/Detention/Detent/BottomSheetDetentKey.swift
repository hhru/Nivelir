#if canImport(UIKit)
import Foundation

public struct BottomSheetDetentKey: Hashable, RawRepresentable, Sendable {

    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

extension BottomSheetDetentKey {

    public static var content: Self {
        Self(rawValue: #function)
    }

    public static var large: Self {
        Self(rawValue: #function)
    }

    public static var medium: Self {
        Self(rawValue: #function)
    }
}
#endif
