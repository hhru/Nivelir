#if canImport(UIKit)
import UIKit

public protocol SnackBarContentView: UIView {

    associatedtype Content: SnackBarContent

    var content: Content { get }

    init(content: Content)
}
#endif
