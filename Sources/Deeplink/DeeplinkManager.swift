#if canImport(UIKit)
import UIKit

#if canImport(UserNotifications)
import UserNotifications
#endif

public final class DeeplinkManager: DeeplinkHandler {

    public let deeplinkTypes: [AnyDeeplink.Type]
    public let navigator: ScreenNavigator

    public private(set) var screens: Any?

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
        navigator: ScreenNavigator
    ) {
        self.deeplinkTypes = deeplinkTypes
        self.navigator = navigator
    }

    private func navigateIfPossible() {
        guard isActive, UIApplication.shared.applicationState == .active else {
            return
        }

        guard let deeplink = pendingDeeplink else {
            return
        }

        pendingDeeplink = nil

        do {
            try deeplink.navigateIfPossible(
                screens: screens,
                navigator: navigator,
                handler: self
            )
        } catch {
            navigator.logError(error)
        }
    }

    private func handleDeeplinkIfPossible(_ deeplink: AnyDeeplink?) -> Bool {
        if let deeplink = deeplink {
            pendingDeeplink = deeplink
        }

        return deeplink != nil
    }

    private func handleErrorIfPossible(_ error: Error) throws {
        guard let decodingError = error as? DeeplinkDecodingError else {
            throw error
        }

        navigator.logInfo("\(decodingError)")
    }

    private func makeURLDeeplinkIfPossible(
        of deeplinkType: AnyURLDeeplink.Type,
        url: URL,
        context: Any?
    ) throws -> AnyURLDeeplink? {
        let queryOptions = try deeplinkType.urlQueryOptions(context: context)

        let queryDecoder = URLQueryDecoder(
            dateDecodingStrategy: queryOptions.dateDecodingStrategy,
            dataDecodingStrategy: queryOptions.dataDecodingStrategy,
            nonConformingFloatDecodingStrategy: queryOptions.nonConformingFloatDecodingStrategy,
            keyDecodingStrategy: queryOptions.keyDecodingStrategy,
            userInfo: queryOptions.userInfo
        )

        do {
            return try deeplinkType.url(
                url,
                queryDecoder: queryDecoder,
                context: context
            )
        } catch {
            try handleErrorIfPossible(error)
        }

        return nil
    }

    #if canImport(UserNotifications) && os(iOS)
    private func makeNotificationDeeplinkIfPossible(
        of deeplinkType: AnyNotificationDeeplink.Type,
        response: UNNotificationResponse,
        context: Any?
    ) throws -> AnyNotificationDeeplink? {
        let userInfoOptions = try deeplinkType.notificationUserInfoOptions(context: context)

        let userInfoDecoder = DictionaryDecoder(
            dateDecodingStrategy: userInfoOptions.dateDecodingStrategy,
            dataDecodingStrategy: userInfoOptions.dataDecodingStrategy,
            nonConformingFloatDecodingStrategy: userInfoOptions.nonConformingFloatDecodingStrategy,
            keyDecodingStrategy: userInfoOptions.keyDecodingStrategy,
            userInfo: userInfoOptions.userInfo
        )

        do {
            return try deeplinkType.notification(
                response: response,
                userInfoDecoder: userInfoDecoder,
                context: context
            )
        } catch {
            try handleErrorIfPossible(error)
        }

        return nil
    }
    #endif

    #if canImport(UIKit) && os(iOS)
    private func makeShortcutDeeplinkIfPossible(
        of deeplinkType: AnyShortcutDeeplink.Type,
        shortcut: UIApplicationShortcutItem,
        context: Any?
    ) throws -> AnyShortcutDeeplink? {
        let userInfoOptions = try deeplinkType.shortcutUserInfoOptions(context: context)

        let userInfoDecoder = DictionaryDecoder(
            dateDecodingStrategy: userInfoOptions.dateDecodingStrategy,
            dataDecodingStrategy: userInfoOptions.dataDecodingStrategy,
            nonConformingFloatDecodingStrategy: userInfoOptions.nonConformingFloatDecodingStrategy,
            keyDecodingStrategy: userInfoOptions.keyDecodingStrategy,
            userInfo: userInfoOptions.userInfo
        )

        do {
            return try deeplinkType.shortcut(
                shortcut,
                userInfoDecoder: userInfoDecoder,
                context: context
            )
        } catch {
            try handleErrorIfPossible(error)
        }

        return nil
    }
    #endif

    @discardableResult
    public func handleURL(_ url: URL, context: Any?) throws -> Bool {
        let deeplink = try deeplinkTypes
            .lazy
            .compactMap { $0 as? AnyURLDeeplink.Type }
            .compactMap { deeplinkType in
                try self.makeURLDeeplinkIfPossible(
                    of: deeplinkType,
                    url: url,
                    context: context
                )
            }
            .first { _ in true }

        return handleDeeplinkIfPossible(deeplink)
    }

    @discardableResult
    public func handleURLIfPossible(_ url: URL, context: Any?) -> Bool {
        do {
            return try handleURL(url, context: context)
        } catch {
            navigator.logError(error)
        }

        return false
    }

    #if canImport(UserNotifications) && os(iOS)
    @discardableResult
    public func handleNotification(response: UNNotificationResponse, context: Any?) throws -> Bool {
        let deeplink = try deeplinkTypes
            .lazy
            .compactMap { $0 as? AnyNotificationDeeplink.Type }
            .compactMap { deeplinkType in
                try makeNotificationDeeplinkIfPossible(
                    of: deeplinkType,
                    response: response,
                    context: context
                )
            }
            .first { _ in true }

        return handleDeeplinkIfPossible(deeplink)
    }

    @discardableResult
    public func handleNotificationIfPossible(response: UNNotificationResponse, context: Any?) -> Bool {
        do {
            return try handleNotification(response: response, context: context)
        } catch {
            navigator.logError(error)
        }

        return false
    }
    #endif

    #if canImport(UIKit) && os(iOS)
    @discardableResult
    public func handleShortcut(_ shortcut: UIApplicationShortcutItem, context: Any?) throws -> Bool {
        let deeplink = try deeplinkTypes
            .lazy
            .compactMap { $0 as? AnyShortcutDeeplink.Type }
            .compactMap { deeplinkType in
                try makeShortcutDeeplinkIfPossible(
                    of: deeplinkType,
                    shortcut: shortcut,
                    context: context
                )
            }
            .first { _ in true }

        return handleDeeplinkIfPossible(deeplink)
    }

    @discardableResult
    public func handleShortcutIfPossible(_ shortcut: UIApplicationShortcutItem, context: Any?) -> Bool {
        do {
            return try handleShortcut(shortcut, context: context)
        } catch {
            navigator.logError(error)
        }

        return false
    }
    #endif

    public func activate(screens: Any?) {
        self.screens = screens

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
