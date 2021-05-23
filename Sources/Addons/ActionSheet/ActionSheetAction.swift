#if canImport(UIKit)
import UIKit

public struct ActionSheetAction {

    public typealias Handler = () -> Void

    public let title: String
    public let style: UIAlertAction.Style
    public let handler: Handler?

    public init(
        title: String,
        style: UIAlertAction.Style = .default,
        handler: Handler? = nil
    ) {
        self.title = title
        self.style = style
        self.handler = handler
    }
}

extension ActionSheetAction {

    public static func cancel(title: String) -> Self {
        Self(title: title, style: .cancel)
    }
}
#endif
