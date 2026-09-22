#if canImport(UIKit) && os(iOS)
import UIKit

/// Action to show the `UIActivityViewController`.
public struct ScreenShareAction<Container: UIViewController>: ScreenAction {

    public typealias Output = UIActivityViewController

    public let sharing: Sharing
    public let animated: Bool

    public init(
        _ sharing: Sharing,
        animated: Bool = true
    ) {
        self.sharing = sharing
        self.animated = animated
    }

    private func showActivitiesContainer(
        _ activitiesContainer: UIActivityViewController,
        on container: Container,
        completion: @escaping Completion
    ) {
        container.present(activitiesContainer, animated: animated) {
            completion(.success(activitiesContainer))
        }
    }

    private func showActivitiesContainerInPopover(
        _ activitiesContainer: UIActivityViewController,
        on container: Container,
        completion: @escaping Completion
    ) {
        guard let popoverPresentationController = activitiesContainer.popoverPresentationController else {
            return showActivitiesContainer(
                activitiesContainer,
                on: container,
                completion: completion
            )
        }

        if let permittedArrowDirections = sharing.anchor.permittedArrowDirections {
            popoverPresentationController.permittedArrowDirections = permittedArrowDirections
        }

        popoverPresentationController.sourceRect = sharing.anchor.rect ?? CGRect(
            x: container.view.bounds.midX,
            y: container.view.bounds.midY,
            width: .zero,
            height: .zero
        )

        popoverPresentationController.sourceView = sharing
            .anchor
            .view ?? container.view

        popoverPresentationController.barButtonItem = sharing
            .anchor
            .barButtonItem

        showActivitiesContainer(
            activitiesContainer,
            on: container,
            completion: completion
        )
    }

    private func makeActivitiesContainer(navigator: ScreenNavigator) -> UIActivityViewController {
        let sharingContainer = UIActivityViewController(
            activityItems: sharing
                .items
                .map { $0.activityItem },
            applicationActivities: sharing
                .applicationActivities
                .map { $0.activity(navigator: navigator) }
                .nonEmpty
        )

        sharing.didInitialize?(sharingContainer)

        sharingContainer.excludedActivityTypes = sharing.excludedActivityTypes.nonEmpty

        #if swift(>=5.6)
        if #available(iOS 15.4, *) {
            sharingContainer.allowsProminentActivity = sharing.allowsProminentActivity
        }
        #endif

        sharingContainer.completionWithItemsHandler = { activityType, completed, items, error in
            sharing.didFinish?(
                activityType,
                completed,
                items?.map(SharingItem.init(activityItem:)),
                error
            )
        }

        return sharingContainer
    }

    public func perform(
        container: Container,
        navigator: ScreenNavigator,
        completion: @escaping Completion
    ) {
        navigator.logInfo("Sharing \(sharing.items) on \(type(of: container))")

        guard container.presented == nil else {
            return completion(.containerAlreadyPresenting(container, for: self))
        }

        let activitiesContainer = makeActivitiesContainer(navigator: navigator)

        switch UIDevice.current.userInterfaceIdiom {
        case .pad, .mac, .vision:
            showActivitiesContainerInPopover(
                activitiesContainer,
                on: container,
                completion: completion
            )

        case .phone, .tv, .carPlay, .unspecified:
            showActivitiesContainer(
                activitiesContainer,
                on: container,
                completion: completion
            )

        @unknown default:
            showActivitiesContainer(
                activitiesContainer,
                on: container,
                completion: completion
            )
        }
    }
}

extension ScreenThenable where Current: UIViewController {

    /// Presents an activity view controller.
    ///
    /// The system provides several standard services,
    /// such as copying items to the pasteboard,
    /// posting content to social media sites, sending items via email or SMS, and more.
    /// Apps can also define custom services.
    /// - Parameters:
    ///   - sharing: An object for configuring the activity view controller.
    ///   - animated: Pass `true` to animate the presentation; otherwise, pass `false`.
    ///   - route: Nested route to be performed in the `UIActivityViewController`.
    /// - Returns: An instance containing the new action.
    public func share<Route: ScreenThenable>(
        _ sharing: Sharing,
        animated: Bool = true,
        route: Route
    ) -> Self where Route.Root == UIActivityViewController {
        fold(
            action: ScreenShareAction<Current>(
                sharing,
                animated: animated
            ),
            nested: route
        )
    }

    /// Presents an activity view controller.
    ///
    /// The system provides several standard services,
    /// such as copying items to the pasteboard,
    /// posting content to social media sites, sending items via email or SMS, and more.
    /// Apps can also define custom services.
    /// - Parameters:
    ///   - sharing: An object for configuring the activity view controller.
    ///   - animated: Pass `true` to animate the presentation; otherwise, pass `false`.
    ///   - route: Nested route to be performed in the `UIActivityViewController`.
    /// - Returns: An instance containing the new action.
    public func share(
        _ sharing: Sharing,
        animated: Bool = true,
        route: (
            _ route: ScreenRootRoute<UIActivityViewController>
        ) -> ScreenRouteConvertible = { $0 }
    ) -> Self {
        share(
            sharing,
            animated: animated,
            route: route(.initial).route()
        )
    }
}
#endif
