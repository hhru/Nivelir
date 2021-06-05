#if canImport(UIKit) && os(iOS)
import UIKit

public struct DocumentPreview: CustomStringConvertible {

    public let url: URL
    public let uti: String?
    public let name: String?
    public let annotation: Any?
    public let anchor: DocumentPreviewAnchor?

    public let willBeginPreview: (() -> Void)?
    public let didEndPreview: (() -> Void)?

    public let willBeginSendingToApplication: ((_ bundleID: String?) -> Void)?
    public let didEndSendingToApplication: ((_ bundleID: String?) -> Void)?

    public var description: String {
        "DocumentPreview(\"\(url)\")"
    }

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
    }
}

#endif
