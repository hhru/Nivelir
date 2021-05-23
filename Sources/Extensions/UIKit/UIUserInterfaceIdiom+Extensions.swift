#if canImport(UIKit)
import UIKit

extension UIUserInterfaceIdiom {

    internal var prefersToPresentUsingPopover: Bool {
        switch self {
        case .pad, .tv, .mac:
            return true

        case .phone, .carPlay, .unspecified:
            return false

        @unknown default:
            return false
        }
    }
}
#endif
