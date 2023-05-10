#if canImport(UIKit)
import Foundation

internal protocol BottomSheetDetentionDelegate: AnyObject {

    func bottomSheetCanEndEditing() -> Bool
    func bottomSheetDidChangeSelectedDetentKey(to detentKey: BottomSheetDetentKey?)
}
#endif
