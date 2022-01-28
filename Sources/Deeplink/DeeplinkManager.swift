#if canImport(UIKit)
import UIKit

public final class DeeplinkManager {

    public let deeplinkTypes: [AnyDeeplink.Type]

    public let routes: Any
    public let navigator: ScreenNavigator

    public let urlQueryDecoder: URLDeeplinkQueryDecoder
    public let notificationUserInfoDecoder: NotificationDeeplinkUserInfoDecoder
    public let shortcutUserInfoDecoder: ShortcutDeeplinkUserInfoDecoder

    public var isActive: Bool {
        applicationStateSubscription != nil
    }

    private var applicationStateSubscription: Any? {
        didSet { navigateIfPossible() }
    }

    private var pendingDeeplink: AnyDeeplink? {
        didSet { navigateIfPossible() }
    }

    public init(
        deeplinkTypes: [AnyDeeplink.Type],
        routes: Any,
        navigator: ScreenNavigator,
        urlQueryDecoder: URLDeeplinkQueryDecoder,
        notificationUserInfoDecoder: NotificationDeeplinkUserInfoDecoder,
        shortcutUserInfoDecoder: ShortcutDeeplinkUserInfoDecoder
    ) {
        self.deeplinkTypes = deeplinkTypes

        self.routes = routes
        self.navigator = navigator

        self.urlQueryDecoder = urlQueryDecoder
        self.notificationUserInfoDecoder = notificationUserInfoDecoder
        self.shortcutUserInfoDecoder = shortcutUserInfoDecoder
    }

    private func handleDeeplinkIfNeeded(_ deeplink: AnyDeeplink?) -> Bool {
        if let deeplink = deeplink {
            pendingDeeplink = deeplink
        }

        return deeplink != nil
    }

    private func navigateIfPossible() {
        guard isActive, UIApplication.shared.applicationState == .active else {
            return
        }

        guard let deeplink = pendingDeeplink else {
            return
        }

        pendingDeeplink = nil

        deeplink.navigateIfPossible(
            using: routes,
            navigator: navigator
        )
    }

    @discardableResult
    public func handleURL(_ url: URL) -> Bool {
        let deeplink = deeplinkTypes
            .lazy
            .compactMap { $0 as? AnyURLDeeplink.Type }
            .compactMap { deeplinkType in
                deeplinkType.url(
                    url,
                    queryDecoder: self.urlQueryDecoder
                )
            }
            .first { _ in true }

        return handleDeeplinkIfNeeded(deeplink)
    }

    @discardableResult
    public func handleNotification(userInfo: [String: Any]) -> Bool {
        let deeplink = deeplinkTypes
            .lazy
            .compactMap { $0 as? AnyNotificationDeeplink.Type }
            .compactMap { deeplinkType in
                deeplinkType.notification(
                    userInfo: userInfo,
                    userInfoDecoder: self.notificationUserInfoDecoder
                )
            }
            .first { _ in true }

        return handleDeeplinkIfNeeded(deeplink)
    }

    #if os(iOS)
    @discardableResult
    public func handleShortcut(_ shortcut: UIApplicationShortcutItem) -> Bool {
        let deeplink = deeplinkTypes
            .lazy
            .compactMap { $0 as? AnyShortcutDeeplink.Type }
            .compactMap { deeplinkType in
                deeplinkType.shortcut(
                    shortcut,
                    userInfoDecoder: self.shortcutUserInfoDecoder
                )
            }
            .first { _ in true }

        return handleDeeplinkIfNeeded(deeplink)
    }
    #endif

    public func activate() {
        guard applicationStateSubscription == nil else {
            return
        }

        applicationStateSubscription = NotificationCenter.default.addObserver(
            forName: UIApplication.didBecomeActiveNotification,
            object: nil,
            queue: nil
        ) { [weak self] _ in
            self?.navigateIfPossible()
        }
    }

    public func deactivate() {
        if let applicationStateSubscription = applicationStateSubscription {
            NotificationCenter.default.removeObserver(applicationStateSubscription)
        }

        applicationStateSubscription = nil
    }
}
#endif
