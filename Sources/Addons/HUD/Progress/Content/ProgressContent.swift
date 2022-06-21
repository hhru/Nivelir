#if canImport(UIKit)
import UIKit

public protocol ProgressContent: AnyProgressContent, Equatable {

    associatedtype View: ProgressContentView where View.Content == Self

    func updateContentView(_ contentView: View) -> View
}

extension ProgressContent {

    public func updateContentView(_ contentView: View) -> View {
        View(content: self)
    }

    public func updateContentViewIfPossible(_ contentView: UIView?) -> UIView {
        guard let contentView = contentView as? View else {
            return View(content: self)
        }

        if contentView.content == self {
            return contentView
        }

        return updateContentView(contentView)
    }
}
#endif
