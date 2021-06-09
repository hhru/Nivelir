#if canImport(UIKit) && os(iOS)
import UIKit

public struct ScreenShowDocumentPreviewAction<Container: UIViewController>: ScreenAction {

    public typealias Output = UIDocumentInteractionController

    public let documentPreview: DocumentPreview
    public let animated: Bool

    public init(documentPreview: DocumentPreview, animated: Bool = true) {
        self.documentPreview = documentPreview
        self.animated = animated
    }

    public func perform(
        container: Container,
        navigator: ScreenNavigator,
        completion: @escaping Completion
    ) {
        navigator.logInfo("Presenting preview for \(documentPreview) on \(type(of: container))")

        let documentInteractionController = UIDocumentInteractionController(
            url: documentPreview.url
        )

        let documentPreviewManager = DocumentPreviewManager(
            documentPreview: documentPreview,
            container: container
        )

        documentInteractionController.screenPayload.store(documentPreviewManager)
        documentInteractionController.delegate = documentPreviewManager

        documentInteractionController.uti = documentPreview.uti
        documentInteractionController.name = documentPreview.name
        documentInteractionController.annotation = documentPreview.annotation

        documentInteractionController.presentPreview(animated: animated)

        DispatchQueue.main.async {
            completion(.success(documentInteractionController))
        }
    }
}

extension ScreenRoute where Current: UIViewController {

    public func showDocumentPreview<Next: ScreenContainer>(
        _ documentPreview: DocumentPreview,
        animated: Bool = true,
        route: ScreenRoute<UIDocumentInteractionController, Next>
    ) -> Self {
        fold(
            action: ScreenShowDocumentPreviewAction<Current>(
                documentPreview: documentPreview,
                animated: animated
            ),
            nested: route
        )
    }

    public func showDocumentPreview(
        _ documentPreview: DocumentPreview,
        animated: Bool = true,
        route: (
            _ route: ScreenRootRoute<UIDocumentInteractionController>
        ) -> ScreenRouteConvertible = { $0 }
    ) -> Self {
        showDocumentPreview(
            documentPreview,
            animated: animated,
            route: route(.initial).route()
        )
    }
}
#endif
