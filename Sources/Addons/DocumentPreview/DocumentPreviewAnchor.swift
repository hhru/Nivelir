#if canImport(UIKit) && os(iOS)
import UIKit

public struct DocumentPreviewAnchor {

    public let rect: CGRect?
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

    public static let center = Self()

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

    public static func rect(_ rect: CGRect, of view: UIView? = nil) -> Self {
        Self(
            rect: rect,
            view: view
        )
    }
}
#endif
