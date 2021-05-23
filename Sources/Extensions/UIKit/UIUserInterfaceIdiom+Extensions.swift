#if canImport(UIKit)
import UIKit

extension UIUserInterfaceIdiom {

    internal var prefersToPresentUsingPopover: Bool {
        switch self {
        case .pad, .mac:
            return true

        case .phone, .tv, .carPlay, .unspecified:
            return false

        @unknown default:
            return false
        }
    }
}
#endif
