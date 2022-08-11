#if canImport(UIKit) && os(iOS)
import UIKit

/// Action that displays the `UIDocumentInteractionController`.
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

extension ScreenThenable where Current: UIViewController {

    /// Displays a full-screen preview of the target document.
    ///
    /// This method displays the document preview using `UIDocumentInteractionController`.
    /// The document interaction controller dismisses
    /// the document preview automatically in response to appropriate user interactions.
    ///
    /// You can also use closures in ``DocumentPreview`` participate
    /// in interactions occurring within the presented interface.
    /// For example, ``DocumentPreview/willBeginSendingToApplication`` is called
    /// when a file is about to be handed off to another application for opening.
    /// See ``DocumentPreview`` for a complete description of the properties you can configure.
    /// - Parameters:
    ///   - documentPreview: An object for configuring the display and handling of target document events.
    ///   - animated: Specify `true` to animate the appearance of the document preview
    ///   or `false` to display it immediately.
    ///   - route: Nested route to be performed in the `UIDocumentInteractionController`.
    /// - Returns: An instance containing the new action.
    public func showDocumentPreview<Route: ScreenThenable>(
        _ documentPreview: DocumentPreview,
        animated: Bool = true,
        route: Route
    ) -> Self where Route.Root == UIDocumentInteractionController {
        fold(
            action: ScreenShowDocumentPreviewAction<Current>(
                documentPreview: documentPreview,
                animated: animated
            ),
            nested: route
        )
    }

    /// Displays a full-screen preview of the target document.
    ///
    /// This method displays the document preview using `UIDocumentInteractionController`.
    /// The document interaction controller dismisses
    /// the document preview automatically in response to appropriate user interactions.
    ///
    /// You can also use closures in ``DocumentPreview`` participate
    /// in interactions occurring within the presented interface.
    /// For example, ``DocumentPreview/willBeginSendingToApplication`` is called
    /// when a file is about to be handed off to another application for opening.
    /// See ``DocumentPreview`` for a complete description of the properties you can configure.
    /// - Parameters:
    ///   - documentPreview: An object for configuring the display and handling of target document events.
    ///   - animated: Specify `true` to animate the appearance of the document preview
    ///   or `false` to display it immediately.
    ///   - route: Nested route to be performed in the `UIDocumentInteractionController`.
    /// - Returns: An instance containing the new action.
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
