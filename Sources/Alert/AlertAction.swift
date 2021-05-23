#if canImport(UIKit)
import UIKit

public struct AlertAction {

    public typealias Handler = ((_ action: AlertAction) -> Void)

    public let title: String
    public let style: UIAlertAction.Style
    public let handler: Handler?

    internal var containerAction: UIAlertAction {
        UIAlertAction(title: title, style: style) { _ in
            handler?(self)
        }
    }

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
