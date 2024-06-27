#if canImport(UIKit) && canImport(SafariServices) && os(iOS)
import UIKit
import SafariServices

/// Action to show the `SFSafariViewController`.
public struct ScreenShowSafariAction<Container: UIViewController>: ScreenAction {

    public typealias Output = SFSafariViewController

    public let safari: Safari
    public let animated: Bool

    public init(
        safari: Safari,
        animated: Bool = true
    ) {
        self.safari = safari
        self.animated = animated
    }

    public func perform(
        container: Container,
        navigator: ScreenNavigator,
        completion: @escaping Completion
    ) {
        navigator.logInfo("Presenting \(safari) on \(type(of: container))")

        guard container.presented == nil else {
            return completion(.containerAlreadyPresenting(container, for: self))
        }

        guard safari.url.scheme.map({ ["http", "https"].contains($0) }) ?? false else {
            return completion(.invalidSafariURL(for: self))
        }

        let safariContainer: SFSafariViewController

        if #available(iOS 11.0, *) {
            let configuration = safari.configuration

            safariContainer = SFSafariViewController(
                url: safari.url,
                configuration: configuration
            )
        } else {
            safariContainer = SFSafariViewController(url: safari.url)
        }

        if #available(iOS 11.0, *) {
            safariContainer.dismissButtonStyle = safari.dismissButtonStyle
        }

        safariContainer.preferredBarTintColor = safari.preferredBarTintColor
        safariContainer.preferredControlTintColor = safari.preferredControlTintColor

        safari.didInitialize?(safariContainer)

        let safariManager = SafariManager(
            safari: safari,
            navigator: navigator
        )

        safariContainer.screenPayload.store(safariManager)
        safariContainer.delegate = safariManager

        container.present(safariContainer, animated: animated) {
            completion(.success(safariContainer))
        }
    }
}

extension ScreenThenable where Current: UIViewController {

    /// Presents a Safari.
    /// - Parameters:
    ///   - safari: An object for configuring the web browsing interface.
    ///   - animated: Pass `true` to animate the presentation; otherwise, pass `false`.
    ///   - route: Nested route to be performed in the `SFSafariViewController`.
    /// - Returns: An instance containing the new action.
    public func showSafari<Route: ScreenThenable>(
        _ safari: Safari,
        animated: Bool = true,
        route: Route
    ) -> Self where Route.Root == SFSafariViewController {
        fold(
            action: ScreenShowSafariAction<Current>(
                safari: safari,
                animated: animated
            ),
            nested: route
        )
    }

    /// Presents a Safari.
    /// - Parameters:
    ///   - safari: An object for configuring the web browsing interface.
    ///   - animated: Pass `true` to animate the presentation; otherwise, pass `false`.
    ///   - route: Nested route to be performed in the `SFSafariViewController`.
    /// - Returns: An instance containing the new action.
    public func showSafari(
        _ safari: Safari,
        animated: Bool = true,
        route: (
            _ route: ScreenRootRoute<SFSafariViewController>
        ) -> ScreenRouteConvertible = { $0 }
    ) -> Self {
        showSafari(
            safari,
            animated: animated,
            route: route(.initial).route()
        )
    }
}
#endif
