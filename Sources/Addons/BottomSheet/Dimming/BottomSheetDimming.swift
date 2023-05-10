#if canImport(UIKit)
import UIKit

public struct BottomSheetDimming: Equatable {

    public static let `default` = Self()

    public let color: UIColor
    public let blurStyle: UIBlurEffect.Style?
    public let largestUndimmedDetentKey: BottomSheetDetentKey?

    public init(
        color: UIColor = UIColor.black.withAlphaComponent(0.6),
        blurStyle: UIBlurEffect.Style? = nil,
        largestUndimmedDetentKey: BottomSheetDetentKey? = nil
    ) {
        self.color = color
        self.blurStyle = blurStyle
        self.largestUndimmedDetentKey = largestUndimmedDetentKey
    }
}
#endif
