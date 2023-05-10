#if canImport(UIKit)
import UIKit

extension CACornerMask {

    internal static var allCorners: CACornerMask {
        [
            .layerMinXMinYCorner,
            .layerMinXMaxYCorner,
            .layerMaxXMinYCorner,
            .layerMaxXMaxYCorner
        ]
    }

    internal var rectCorners: UIRectCorner {
        let cornerMaskMap: KeyValuePairs<CACornerMask, UIRectCorner> = [
            .layerMinXMinYCorner: .topLeft,
            .layerMinXMaxYCorner: .bottomLeft,
            .layerMaxXMinYCorner: .topRight,
            .layerMaxXMaxYCorner: .bottomRight
        ]

        return cornerMaskMap
            .lazy
            .filter { contains($0.key) }
            .reduce(into: UIRectCorner()) { result, corner in
                result.insert(corner.value)
            }
    }
}
#endif
