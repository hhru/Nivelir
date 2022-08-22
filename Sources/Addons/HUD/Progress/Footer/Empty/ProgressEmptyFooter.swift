#if canImport(UIKit)
import Foundation

/// Empty footer of progress.
public struct ProgressEmptyFooter: ProgressFooter {

    public typealias View = ProgressEmptyFooterView

    /// Default instance
    public static let `default` = Self()

    private init() { }
}
#endif
