#if canImport(UIKit)
import Foundation

internal enum BottomSheetPresentationState {

    case presenting
    case presented
    case dismissing
    case dismissed

    internal var canAnimateChanges: Bool {
        switch self {
        case .presenting, .presented, .dismissing:
            return true

        case .dismissed:
            return false
        }
    }
}
#endif
