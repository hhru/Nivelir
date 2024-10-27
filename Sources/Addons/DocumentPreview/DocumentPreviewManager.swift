#if canImport(UIKit) && os(iOS)
import UIKit

internal final class DocumentPreviewManager:
    NSObject,
    UIDocumentInteractionControllerDelegate {

    private let documentPreview: DocumentPreview
    private let container: UIViewController

    internal init(
        documentPreview: DocumentPreview,
        container: UIViewController
    ) {
        self.documentPreview = documentPreview
        self.container = container
    }

    internal func documentInteractionControllerViewControllerForPreview(
        _ controller: UIDocumentInteractionController
    ) -> UIViewController {
        container
    }

    internal func documentInteractionControllerViewForPreview(
        _ controller: UIDocumentInteractionController
    ) -> UIView? {
        documentPreview.anchor.map { anchor in
            MainActor.assumeIsolated { [container] in
                anchor.view ?? container.view
            }
        }
    }

    internal func documentInteractionControllerRectForPreview(
        _ controller: UIDocumentInteractionController
    ) -> CGRect {
        documentPreview.anchor.map { anchor in
            MainActor.assumeIsolated { [container] in
                anchor.rect ?? CGRect(
                    x: container.view.bounds.midX,
                    y: container.view.bounds.midY,
                    width: .zero,
                    height: .zero
                )
            }
        } ?? .zero
    }

    internal func documentInteractionControllerWillBeginPreview(
        _ controller: UIDocumentInteractionController
    ) {
        documentPreview.willBeginPreview?()
    }

    internal func documentInteractionControllerDidEndPreview(
        _ controller: UIDocumentInteractionController
    ) {
        documentPreview.didEndPreview?()
    }

    internal func documentInteractionController(
        _ controller: UIDocumentInteractionController,
        willBeginSendingToApplication application: String?
    ) {
        documentPreview.willBeginSendingToApplication?(application)
    }

    internal  func documentInteractionController(
        _ controller: UIDocumentInteractionController,
        didEndSendingToApplication application: String?
    ) {
        documentPreview.didEndSendingToApplication?(application)
    }
}

#endif
