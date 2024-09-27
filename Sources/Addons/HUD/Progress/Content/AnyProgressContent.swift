#if canImport(UIKit)
import UIKit

/// Erased protocol type ``ProgressContent``.
///
/// - SeeAlso: ``ProgressContent``
@MainActor
public protocol AnyProgressContent {

    /// A console log representation of `self`.
    var logDescription: String? { get }

    /// Updates or creates a new instance of the content view using this content
    /// if the `contentView` type matches the ``ProgressContent/View`` type.
    /// - Parameter contentView: The current view associated with the content.
    func updateContentViewIfPossible(_ contentView: UIView?) -> UIView
}

extension AnyProgressContent {

    public var logDescription: String? {
        nil
    }
}
#endif
