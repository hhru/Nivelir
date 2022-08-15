#if canImport(UIKit)
import UIKit

/// A type that contains the data to be displayed on the ``View``.
///
/// This protocol provides a blueprint for a content object, which encompasses content for a content view.
/// The content encapsulates all of the supported properties and behaviors for content view customization.
/// You use the content to create the content view.
public protocol ProgressContent: AnyProgressContent, Equatable {

    /// The view type associated with the content.
    /// The view must be associated with this content type, creating a one-to-one relationship.
    associatedtype View: ProgressContentView where View.Content == Self

    /// Updates or creates a new instance of the content view using this content.
    /// - Parameter contentView: The current view associated with the content.
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
