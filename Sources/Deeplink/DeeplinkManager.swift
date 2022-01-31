#if canImport(UIKit)
import UIKit

public final class DeeplinkManager: DeeplinkHandler {

    public let deeplinkTypes: [AnyDeeplink.Type]
    public let navigator: ScreenNavigator

    public private(set) var routes: Any?

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
                routes: routes,
                handler: self
            )
        } catch {
            navigator.logError(error)
        }
    }

    private func handleDeeplinkError(_ error: Error) throws {
        guard let error = error as? DeeplinkDecodingError else {
            throw error
        }

        navigator.logInfo("\(error)")
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
            try handleDeeplinkError(error)
        }

        return nil
    }

    private func makeNotificationDeeplinkIfPossible(
        of deeplinkType: AnyNotificationDeeplink.Type,
        userInfo: [String: Any],
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
                userInfo: userInfo,
                userInfoDecoder: userInfoDecoder,
                context: context
            )
        } catch {
            try handleDeeplinkError(error)
        }

        return nil
    }

    #if os(iOS)
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
            try handleDeeplinkError(error)
        }

        return nil
    }
    #endif
    private func handleDeeplinkIfPossible(_ deeplink: AnyDeeplink?) -> Bool {
        if let deeplink = deeplink {
            pendingDeeplink = deeplink
        }

        return deeplink != nil
    }

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
    public func handleNotification(userInfo: [String: Any], context: Any?) throws -> Bool {
        let deeplink = try deeplinkTypes
            .lazy
            .compactMap { $0 as? AnyNotificationDeeplink.Type }
            .compactMap { deeplinkType in
                try makeNotificationDeeplinkIfPossible(
                    of: deeplinkType,
                    userInfo: userInfo,
                    context: context
                )
            }
            .first { _ in true }

        return handleDeeplinkIfPossible(deeplink)
    }

    #if os(iOS)
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
    #endif

    public func activate(routes: Any?) {
        self.routes = routes

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
