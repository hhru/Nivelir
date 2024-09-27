#if canImport(UIKit) && os(iOS)
import UIKit

/// Anchor of the starting point for animating the display of a document preview.
@MainActor
public struct DocumentPreviewAnchor {

    /// The rectangle to use as the starting point for animating
    /// the display of a document preview in the coordinate system of the ``view``.
    public let rect: CGRect?

    /// The view to use as the starting point for the animation
    /// or `nil` if you want the document preview to fade into place.
    public let view: UIView?

    private init(
        rect: CGRect? = nil,
        view: UIView? = nil
    ) {
        self.rect = rect
        self.view = view
    }
}

extension DocumentPreviewAnchor {

    /// The center point of the screen to use as the starting point for animating the display of a document preview.
    public static let center = Self()

    /// The center of `view` to use as the starting point for animating the display of a document preview.
    /// - Parameter view: The view to use as the starting point for the animation.
    public static func center(of view: UIView) -> Self {
        Self(
            rect: CGRect(
                origin: CGPoint(
                    x: view.bounds.midX,
                    y: view.bounds.midY
                ),
                size: .zero
            ),
            view: view
        )
    }

    /// The rectangle to use as the starting point for animating the display of a document preview.
    /// - Parameters:
    ///   - rect: A rectangle in the coordinate system of the `view`.
    ///   - view: The view to use as the starting point for the animation
    ///   or `nil` if you want the document preview to fade into place.
    public static func rect(_ rect: CGRect, of view: UIView? = nil) -> Self {
        Self(
            rect: rect,
            view: view
        )
    }
}
#endif
