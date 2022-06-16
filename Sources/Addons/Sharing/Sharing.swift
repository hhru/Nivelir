#if canImport(UIKit) && os(iOS)
import UIKit

public struct Sharing {

    public typealias DidInitialize = (_ container: UIActivityViewController) -> Void

    public typealias DidFinish = (
        _ activityType: SharingActivityType?,
        _ completed: Bool,
        _ items: [SharingItem]?,
        _ error: Error?
    ) -> Void

    private let storedAllowsProminentActivity: Bool?

    public let items: [SharingItem]
    public let applicationActivities: [SharingActivity]
    public let excludedActivityTypes: [SharingActivityType]
    public let anchor: ScreenPopoverPresentationAnchor

    public let didInitialize: DidInitialize?
    public let didFinish: DidFinish?

    @available(iOS 15.4, *)
    public var allowsProminentActivity: Bool {
        storedAllowsProminentActivity ?? true
    }

    public init(
        items: [SharingItem],
        applicationActivities: [SharingActivity] = [],
        excludedActivityTypes: [SharingActivityType] = [],
        anchor: ScreenPopoverPresentationAnchor,
        didInitialize: DidInitialize? = nil,
        didFinish: DidFinish? = nil
    ) {
        self.storedAllowsProminentActivity = nil

        self.items = items
        self.applicationActivities = applicationActivities
        self.excludedActivityTypes = excludedActivityTypes
        self.anchor = anchor

        self.didInitialize = didInitialize
        self.didFinish = didFinish
    }

    @available(iOS 15.4, *)
    public init(
        items: [SharingItem],
        applicationActivities: [SharingActivity] = [],
        excludedActivityTypes: [SharingActivityType] = [],
        allowsProminentActivity: Bool,
        anchor: ScreenPopoverPresentationAnchor,
        didInitialize: DidInitialize? = nil,
        didFinish: DidFinish? = nil
    ) {
        self.storedAllowsProminentActivity = allowsProminentActivity

        self.items = items
        self.applicationActivities = applicationActivities
        self.excludedActivityTypes = excludedActivityTypes
        self.anchor = anchor

        self.didInitialize = didInitialize
        self.didFinish = didFinish
    }
}
#endif
