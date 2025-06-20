#if canImport(UIKit) && os(iOS)
import UIKit

#if canImport(LinkPresentation)
import LinkPresentation
#endif

internal final class SharingItemManager: NSObject, UIActivityItemSource {

    internal let item: SharingCustomItem

    internal init(item: SharingCustomItem) {
        self.item = item
    }

    internal func activityViewControllerPlaceholderItem(
        _ activityViewController: UIActivityViewController
    ) -> Any {
        item.placeholder
    }

    #if canImport(LinkPresentation)
    @available(iOS 13.0, *)
    internal func activityViewControllerLinkMetadata(
        _ activityViewController: UIActivityViewController
    ) -> LPLinkMetadata? {
        item.metadata
    }
    #endif

    internal func activityViewController(
        _ activityViewController: UIActivityViewController,
        itemForActivityType activityType: UIActivity.ActivityType?
    ) -> Any? {
        item.value(for: activityType)
    }

    internal func activityViewController(
        _ activityViewController: UIActivityViewController,
        subjectForActivityType activityType: UIActivity.ActivityType?
    ) -> String {
        item.subject(for: activityType) ?? ""
    }

    internal func activityViewController(
        _ activityViewController: UIActivityViewController,
        dataTypeIdentifierForActivityType activityType: UIActivity.ActivityType?
    ) -> String {
        item.dataTypeIdentifier(for: activityType) ?? ""
    }

    internal func activityViewController(
        _ activityViewController: UIActivityViewController,
        thumbnailImageForActivityType activityType: UIActivity.ActivityType?,
        suggestedSize size: CGSize
    ) -> UIImage? {
        item.thumbnailImage(for: activityType, suggestedSize: size)
    }
}
#endif
