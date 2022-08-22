#if canImport(UIKit)
import Foundation

/// Empty header of progress.
public struct ProgressEmptyHeader: ProgressHeader {

    public typealias View = ProgressEmptyHeaderView

    /// Default instance
    public static let `default` = Self()

    private init() { }
}
#endif
