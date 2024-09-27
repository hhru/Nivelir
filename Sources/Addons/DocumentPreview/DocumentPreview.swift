#if canImport(UIKit) && os(iOS)
import UIKit

/// Object for configuring document display via ``ScreenShowDocumentPreviewAction``.
public struct DocumentPreview: CustomStringConvertible {

    /// The URL identifying the target file on the local filesystem.
    public let url: URL

    /// The type of the target file.
    public let uti: String?

    /// The name of the target file.
    public let name: String?

    /// Custom property list information for the target file.
    public let annotation: Any?

    /// Anchor of the starting point for animating the display of a document preview.
    public let anchor: DocumentPreviewAnchor?

    /// Called when a document interaction controller is about to display a preview for its document.
    public let willBeginPreview: (() -> Void)?

    /// Called when a document interaction controller has dismissed its document preview.
    public let didEndPreview: (() -> Void)?

    /// Called when a document interaction controller’s document is about to be opened by the specified application.
    public let willBeginSendingToApplication: ((_ bundleID: String?) -> Void)?

    /// Called when a document interaction controller’s document has been handed off to the specified application.
    public let didEndSendingToApplication: ((_ bundleID: String?) -> Void)?

    public let description: String

    /// Creates and returns a new `DocumentPreview` object.
    /// - Parameters:
    ///   - url: The URL identifying the target file on the local filesystem.
    ///   - uti: The type of the target file.
    ///   - name: The name of the target file.
    ///   - annotation: Custom property list information for the target file.
    ///   - anchor: Anchor of the starting point for animating the display of a document preview.
    ///   - willBeginPreview: Called when a document interaction controller
    ///   is about to display a preview for its document.
    ///   - didEndPreview: Called when a document interaction controller has dismissed its document preview.
    ///   - willBeginSendingToApplication: Called when a document interaction controller’s document
    ///   is about to be opened by the specified application.
    ///   - didEndSendingToApplication: Called when a document interaction controller’s document
    ///   has been handed off to the specified application.
    public init(
        url: URL,
        uti: String? = nil,
        name: String? = nil,
        annotation: Any? = nil,
        anchor: DocumentPreviewAnchor? = nil,
        willBeginPreview: (() -> Void)? = nil,
        didEndPreview: (() -> Void)? = nil,
        willBeginSendingToApplication: ((_ bundleID: String?) -> Void)? = nil,
        didEndSendingToApplication: ((_ bundleID: String?) -> Void)? = nil
    ) {
        self.url = url
        self.uti = uti
        self.name = name
        self.annotation = annotation
        self.anchor = anchor

        self.willBeginPreview = willBeginPreview
        self.didEndPreview = didEndPreview

        self.willBeginSendingToApplication = willBeginSendingToApplication
        self.didEndSendingToApplication = didEndSendingToApplication

        description = "DocumentPreview(\"\(url)\")"
    }
}

#endif
