#if canImport(UIKit)
import Foundation

public struct ProgressEmptyHeader: ProgressHeader {

    public typealias View = ProgressEmptyHeaderView

    public static let `default` = Self()

    private init() { }
}
#endif
