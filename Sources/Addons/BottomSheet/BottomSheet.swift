#if canImport(UIKit)
import Foundation

public struct BottomSheet {

    public static let `default` = Self()

    public let detents: [BottomSheetDetent]
    public let selectedDetentKey: BottomSheetDetentKey?

    public let preferredDimming: BottomSheetDimming
    public let preferredCard: BottomSheetCard
    public let preferredGrabber: BottomSheetGrabber?
    public let prefferedGrabberForMaximumDetentValue: BottomSheetGrabber?

    public let prefersScrollingExpandsHeight: Bool
    public let prefersWidthFollowsPreferredContentSize: Bool
    public let prefersEdgeAttachedInCompactHeight: Bool

    public let rubberBandEffect: BottomSheetRubberBandEffect?

    public let changesAnimationOptions: BottomSheetAnimationOptions
    public let presentAnimationOptions: BottomSheetAnimationOptions
    public let dismissAnimationOptions: BottomSheetAnimationOptions

    public let canEndEditing: (() -> Bool)?
    public let shouldDismiss: (() -> Bool)?

    public let didAttemptToDismiss: (() -> Void)?

    public let willDismiss: (() -> Void)?
    public let didDismiss: (() -> Void)?

    public let didChangeSelectedDetentKey: ((_ detentKey: BottomSheetDetentKey?) -> Void)?

    public init(
        detents: [BottomSheetDetent] = [.large],
        selectedDetentKey: BottomSheetDetentKey? = nil,
        preferredDimming: BottomSheetDimming = .default,
        preferredCard: BottomSheetCard = .default,
        preferredGrabber: BottomSheetGrabber? = nil,
        prefferedGrabberForMaximumDetentValue: BottomSheetGrabber? = nil,
        prefersScrollingExpandsHeight: Bool = true,
        prefersWidthFollowsPreferredContentSize: Bool = false,
        prefersEdgeAttachedInCompactHeight: Bool = false,
        rubberBandEffect: BottomSheetRubberBandEffect? = .default,
        changesAnimationOptions: BottomSheetAnimationOptions = .changes,
        presentAnimationOptions: BottomSheetAnimationOptions = .transition,
        dismissAnimationOptions: BottomSheetAnimationOptions = .transition,
        canEndEditing: (() -> Bool)? = nil,
        shouldDismiss: (() -> Bool)? = nil,
        didAttemptToDismiss: (() -> Void)? = nil,
        willDismiss: (() -> Void)? = nil,
        didDismiss: (() -> Void)? = nil,
        didChangeSelectedDetentKey: ((_ detentKey: BottomSheetDetentKey?) -> Void)? = nil
    ) {
        self.detents = detents
        self.selectedDetentKey = selectedDetentKey

        self.preferredDimming = preferredDimming
        self.preferredCard = preferredCard
        self.preferredGrabber = preferredGrabber
        self.prefferedGrabberForMaximumDetentValue = prefferedGrabberForMaximumDetentValue

        self.prefersScrollingExpandsHeight = prefersScrollingExpandsHeight
        self.prefersWidthFollowsPreferredContentSize = prefersWidthFollowsPreferredContentSize
        self.prefersEdgeAttachedInCompactHeight = prefersEdgeAttachedInCompactHeight

        self.rubberBandEffect = rubberBandEffect

        self.changesAnimationOptions = changesAnimationOptions
        self.presentAnimationOptions = presentAnimationOptions
        self.dismissAnimationOptions = dismissAnimationOptions

        self.canEndEditing = canEndEditing
        self.shouldDismiss = shouldDismiss

        self.didAttemptToDismiss = didAttemptToDismiss

        self.willDismiss = willDismiss
        self.didDismiss = didDismiss

        self.didChangeSelectedDetentKey = didChangeSelectedDetentKey
    }
}
#endif
