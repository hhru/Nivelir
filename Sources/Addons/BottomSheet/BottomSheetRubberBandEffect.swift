#if canImport(UIKit)
import UIKit

public struct BottomSheetRubberBandEffect: Sendable {

    public let handler: @Sendable (_ delta: CGFloat) -> CGFloat

    public init(handler: @escaping @Sendable (_ delta: CGFloat) -> CGFloat) {
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
