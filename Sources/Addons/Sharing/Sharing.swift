#if canImport(UIKit) && os(iOS)
import UIKit

/// An object for configuring the activity view controller.
public struct Sharing {

    public typealias DidInitialize = (_ container: UIActivityViewController) -> Void

    /// A completion handler to execute after the activity view controller is dismissed.
    ///
    /// Upon the completion of an activity,
    /// or the dismissal of the activity view controller, the view controller’s completion block is executed.
    /// You can use this block to execute any final code related to the service.
    public typealias DidFinish = (
        _ activityType: SharingActivityType?,
        _ completed: Bool,
        _ items: [SharingItem]?,
        _ error: Error?
    ) -> Void

    private let storedAllowsProminentActivity: Bool?

    /// The array of data objects on which to perform the activity.
    /// The type of objects in the array is variable and dependent on the data your application manages.
    /// For example, the data might consist of one
    /// or more string or image objects representing the currently selected content.
    /// This array must not be empty and must contain at least one object.
    public let items: [SharingItem]

    /// An array of ``SharingActivity`` objects representing the custom services that your application supports.
    /// This array may be empty.
    public let applicationActivities: [SharingActivity]

    /// The list of services that should not be displayed.
    public let excludedActivityTypes: [SharingActivityType]

    /// Anchor of the starting point for presenting activity view controller.
    public let anchor: ScreenPopoverPresentationAnchor

    /// A closure that returns the created `UIActivityViewController` in the argument.
    public let didInitialize: DidInitialize?

    /// The completion handler to execute after the activity view controller is dismissed.
    public let didFinish: DidFinish?

    /// In some contexts, the activity view controller can elevate a specific activity in the header view to enhance it.
    /// The prominent activity can only be chosen by the system.
    @available(iOS 15.4, *)
    public var allowsProminentActivity: Bool {
        storedAllowsProminentActivity ?? true
    }

    /// Creates a configuration.
    /// - Parameters:
    ///   - items: The array of data objects on which to perform the activity.
    ///   - applicationActivities: An array of ``SharingActivity`` objects representing the custom services
    ///   that your application supports.
    ///   - excludedActivityTypes: The list of services that should not be displayed.
    ///   - anchor: Anchor of the starting point for presenting activity view controller.
    ///   - didInitialize: A closure that returns the created `UIActivityViewController` in the argument.
    ///   - didFinish: The completion handler to execute after the activity view controller is dismissed.
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

    /// Creates a configuration.
    /// - Parameters:
    ///   - items: The array of data objects on which to perform the activity.
    ///   - applicationActivities: An array of ``SharingActivity`` objects representing the custom services
    ///   that your application supports.
    ///   - excludedActivityTypes: The list of services that should not be displayed.
    ///   - allowsProminentActivity: In some contexts, the activity view controller can elevate
    ///   a specific activity in the header view to enhance it.
    ///   - anchor: Anchor of the starting point for presenting activity view controller.
    ///   - didInitialize: A closure that returns the created `UIActivityViewController` in the argument.
    ///   - didFinish: The completion handler to execute after the activity view controller is dismissed.
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
