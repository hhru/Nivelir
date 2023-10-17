#if canImport(UIKit)
import UIKit

public protocol AnySnackBarContent {

    var logDescription: String? { get }

    func updateContentViewIfPossible(_ contentView: UIView?) -> UIView
}

extension AnySnackBarContent {

    public var logDescription: String? {
        nil
    }
}
#endif
