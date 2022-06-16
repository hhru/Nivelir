#if canImport(UIKit) && os(iOS)
import UIKit

public typealias SharingActivityType = UIActivity.ActivityType

extension SharingActivityType {

    public static func fromPropertyName(_ name: String = #function) -> Self {
        Bundle.main.bundleIdentifier.map { bundleIdentifier in
            Self(rawValue: "\(bundleIdentifier).activity.\(name)")
        } ?? Self(rawValue: "activity.\(name)")
    }
}
#endif
