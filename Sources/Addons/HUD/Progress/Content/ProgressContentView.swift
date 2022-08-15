#if canImport(UIKit)
import UIKit

/// The requirements for a content view that you create using a content.
///
/// This protocol provides a blueprint for a content view object that renders the content that you define.
/// The content view’s content encapsulates all of the supported properties
/// and behaviors for content view customization.
public protocol ProgressContentView: UIView {

    /// The content type associated with the view.
    /// The content must be associated with this view type, creating a one-to-one relationship.
    associatedtype Content: ProgressContent

    /// The current content of the view.
    var content: Content { get }

    /// Creating a view with content.
    /// - Parameter content: Content for the initial setup of the view.
    init(content: Content)
}
#endif
