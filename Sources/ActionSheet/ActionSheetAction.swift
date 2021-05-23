#if canImport(UIKit)
import UIKit

public struct ActionSheetAction {

    public typealias Handler = () -> Void

    public let title: String
    public let style: UIAlertAction.Style
    public let handler: Handler?

    public init(
        title: String,
        style: UIAlertAction.Style,
        handler: Handler? = nil
    ) {
        self.title = title
        self.style = style
        self.handler = handler
    }
}
#endif
