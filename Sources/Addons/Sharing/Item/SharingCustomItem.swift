#if canImport(UIKit) && os(iOS)
import UIKit

#if canImport(LinkPresentation)
import LinkPresentation
#endif

public protocol SharingCustomItem: CustomStringConvertible {

    var placeholder: Any { get }

    #if canImport(LinkPresentation)
    @available(iOS 13.0, *)
    var metadata: LPLinkMetadata? { get }
    #endif

    func value(for activityType: SharingActivityType?) -> Any?
    func subject(for activityType: SharingActivityType?) -> String?

    func dataTypeIdentifier(for activityType: SharingActivityType?) -> String?

    func thumbnailImage(
        for activityType: SharingActivityType?,
        suggestedSize size: CGSize
    ) -> UIImage?
}

extension SharingCustomItem {

    #if canImport(LinkPresentation)
    @available(iOS 13.0, *)
    public var metadata: LPLinkMetadata? {
        nil
    }
    #endif

    public func subject(for activityType: SharingActivityType?) -> String? {
        nil
    }

    public func dataTypeIdentifier(for activityType: SharingActivityType?) -> String? {
        nil
    }

    public func thumbnailImage(
        for activityType: SharingActivityType?,
        suggestedSize size: CGSize
    ) -> UIImage? {
        nil
    }
}
#endif
