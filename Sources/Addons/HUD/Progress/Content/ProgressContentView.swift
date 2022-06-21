#if canImport(UIKit)
import UIKit

public protocol ProgressContentView: UIView {

    associatedtype Content: ProgressContent

    var content: Content { get }

    init(content: Content)
}
#endif
