#if canImport(UIKit)
import UIKit

public protocol AnyProgressContent {

    var logDescription: String? { get }

    func updateContentViewIfPossible(_ contentView: UIView?) -> UIView
}

extension AnyProgressContent {

    public var logDescription: String? {
        nil
    }
}
#endif
