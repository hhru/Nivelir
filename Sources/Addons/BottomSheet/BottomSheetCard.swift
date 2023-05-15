#if canImport(UIKit)
import UIKit

public struct BottomSheetCard: Equatable {

    public static let `default` = Self()

    public let backgroundColor: UIColor?
    public let cornerRadius: CGFloat
    public let border: BottomSheetBorder?
    public let shadow: BottomSheetShadow?
    public let contentInsets: UIEdgeInsets

    public init(
        backgroundColor: UIColor? = nil,
        cornerRadius: CGFloat = 16.0,
        border: BottomSheetBorder? = nil,
        shadow: BottomSheetShadow? = nil,
        contentInsets: UIEdgeInsets = .zero
    ) {
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.border = border
        self.shadow = shadow
        self.contentInsets = contentInsets
    }
}
#endif
