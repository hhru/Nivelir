#if canImport(UIKit)
import UIKit

public struct AlertAction {

    public typealias Enabler = (_ texts: [String]) -> Bool
    public typealias Handler = (_ texts: [String]) -> Void

    public let title: String
    public let style: UIAlertAction.Style
    public let enabler: Enabler?
    public let handler: Handler?

    public init(
        title: String,
        style: UIAlertAction.Style = .default,
        enabler: Enabler? = nil,
        handler: Handler? = nil
    ) {
        self.title = title
        self.style = style
        self.enabler = enabler
        self.handler = handler
    }

    public init(
        title: String,
        style: UIAlertAction.Style = .default,
        enabler: Enabler? = nil,
        handler: (() -> Void)?
    ) {
        self.init(title: title, style: style, enabler: enabler) { _ in
            handler?()
        }
    }
}

extension AlertAction {

    public static func cancel(title: String) -> Self {
        Self(title: title, style: .cancel)
    }
}
#endif
