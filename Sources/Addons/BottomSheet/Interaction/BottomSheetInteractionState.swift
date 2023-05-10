#if canImport(UIKit)
import Foundation

internal enum BottomSheetInteractionState {

    case starting
    case updating
    case finished
    case cancelled

    internal var isActive: Bool {
        switch self {
        case .starting, .updating:
            return true

        case .finished, .cancelled:
            return false
        }
    }
}
#endif
