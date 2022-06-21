#if canImport(UIKit)
import Foundation

public struct ProgressEmptyFooter: ProgressFooter {

    public typealias View = ProgressEmptyFooterView

    public static let `default` = Self()

    private init() { }
}
#endif
