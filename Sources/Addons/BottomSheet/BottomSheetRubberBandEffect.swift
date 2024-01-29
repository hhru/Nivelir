#if canImport(UIKit)
import UIKit

public struct BottomSheetRubberBandEffect {

    public let handler: (_ delta: CGFloat) -> CGFloat

    public init(handler: @escaping (_ delta: CGFloat) -> CGFloat) {
        self.handler = handler
    }

    public func callAsFunction(value: CGFloat, limit: CGFloat) -> CGFloat {
        handler(abs(limit - value))
    }
}

extension BottomSheetRubberBandEffect {

    public static let `default` = Self { delta in
        2.0 * delta.squareRoot()
    }
}
#endif
