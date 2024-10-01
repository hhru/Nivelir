#if canImport(UIKit)
import Foundation

@MainActor
internal protocol BottomSheetDetentionDelegate: AnyObject {

    func bottomSheetCanEndEditing() -> Bool
    func bottomSheetDidChangeSelectedDetentKey(to detentKey: BottomSheetDetentKey?)
}
#endif
