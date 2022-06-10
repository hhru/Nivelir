#if canImport(UIKit)
import UIKit

#if canImport(UserNotifications)
import UserNotifications
#endif

public final class DeeplinkManager: DeeplinkHandler {

    public let deeplinkTypes: [DeeplinkScope: [AnyDeeplink.Type]]
    public let navigator: ScreenNavigator

    public private(set) var screens: [DeeplinkScope: Any?] = [:]

    public var isActive: Bool {
        !screens.isEmpty
    }

    private var applicationStateSubscription: Any? {
        didSet { navigateIfPossible() }
    }

    private var pendingDeeplink: DeeplinkStorage? {
        didSet { navigateIfPossible() }
    }

    public init(
        deeplinkTypes: [DeeplinkScope: [AnyDeeplink.Type]],
        navigator: ScreenNavigator
    ) {
        self.deeplinkTypes = deeplinkTypes
        self.navigator = navigator
    }

    public convenience init(
        deeplinkTypes: [AnyDeeplink.Type],
        navigator: ScreenNavigator
    ) {
        self.init(
            deeplinkTypes: [.default: deeplinkTypes],
            navigator: navigator
        )
    }

    private func navigateIfPossible() {
        guard UIApplication.shared.applicationState == .active else {
            return
        }

        guard let deeplink = pendingDeeplink else {
            return
        }

        guard let screens = screens[deeplink.scope] else {
            return
        }

        pendingDeeplink = nil

        do {
            try deeplink.value.navigateIfPossible(
                screens: screens,
                navigator: navigator,
                handler: self
            )
        } catch {
            navigator.logError(error)
        }
    }

    private func handleDeeplinkIfPossible(_ deeplink: DeeplinkStorage?) -> Bool {
        if let deeplink = deeplink {
            pendingDeeplink = deeplink
        }

        return deeplink != nil
    }

    private func resolveDeeplinkResult(deeplink: AnyDeeplink?, scope: DeeplinkScope) -> DeeplinkResult? {
        guard let deeplink = deeplink else {
            return nil
        }

        let storage = DeeplinkStorage(
            value: deeplink,
            scope: scope
        )

        return .success(storage)
    }

    private func resolveDeeplinkResult(error: Error) -> DeeplinkResult {
        guard let deeplinkError = error as? DeeplinkError else {
            return .failure(error)
        }

        guard deeplinkError.isWarning else {
            return .failure(error)
        }

        return .warning(deeplinkError)
    }

    private func makeDeeplinkIfPossible<T>(
        of deeplinkType: T.Type,
        resolver: @escaping (_ scope: DeeplinkScope, _ index: Int) -> DeeplinkResult?
    ) throws -> DeeplinkStorage? {
        let results = deeplinkTypes
            .lazy
            .compactMap { scope, deeplinkTypes in
                deeplinkTypes
                    .enumerated()
                    .lazy
                    .compactMap { offset, _ in
                        resolver(scope, offset)
                    }
            }
            .flatMap { $0 }

        var warnings: [Error] = []

        for result in results {
            switch result {
            case let .success(deeplink):
                return deeplink

            case let .failure(error):
                throw error

            case let .warning(error):
                warnings.append(error)
            }
        }

        guard warnings.isEmpty else {
            throw DeeplinkWarningsError(
                deeplinkType: deeplinkType,
                warnings: warnings
            )
        }

        return nil
    }

    private func makeURLDeeplinkIfPossible(
        of deeplinkType: AnyURLDeeplink.Type,
        url: URL,
        context: Any?,
        scope: DeeplinkScope
    ) -> DeeplinkResult? {
        do {
            let queryOptions = try deeplinkType.urlQueryOptions(context: context)

            let queryDecoder = URLQueryDecoder(
                dateDecodingStrategy: queryOptions.dateDecodingStrategy,
                dataDecodingStrategy: queryOptions.dataDecodingStrategy,
                nonConformingFloatDecodingStrategy: queryOptions.nonConformingFloatDecodingStrategy,
                keyDecodingStrategy: queryOptions.keyDecodingStrategy,
                userInfo: queryOptions.userInfo
            )

            let deeplink = try deeplinkType.url(
                url,
                queryDecoder: queryDecoder,
                context: context
            )

            return resolveDeeplinkResult(
                deeplink: deeplink,
                scope: scope
            )
        } catch {
            return resolveDeeplinkResult(error: error)
        }
    }

    private func makeURLDeeplinkIfPossible(
        url: URL,
        context: Any?
    ) throws -> DeeplinkStorage? {
        try makeDeeplinkIfPossible(of: AnyURLDeeplink.self) { scope, index in
            self.deeplinkTypes[scope]
                .flatMap { $0[index] as? AnyURLDeeplink.Type }
                .flatMap { deeplinkType in
                    self.makeURLDeeplinkIfPossible(
                        of: deeplinkType,
                        url: url,
                        context: context,
                        scope: scope
                    )
                }
        }
    }

    #if canImport(UserNotifications) && os(iOS)
    private func makeNotificationDeeplinkIfPossible(
        of deeplinkType: AnyNotificationDeeplink.Type,
        response: UNNotificationResponse,
        context: Any?,
        scope: DeeplinkScope
    ) -> DeeplinkResult? {
        do {
            let userInfoOptions = try deeplinkType.notificationUserInfoOptions(context: context)

            let userInfoDecoder = DictionaryDecoder(
                dateDecodingStrategy: userInfoOptions.dateDecodingStrategy,
                dataDecodingStrategy: userInfoOptions.dataDecodingStrategy,
                nonConformingFloatDecodingStrategy: userInfoOptions.nonConformingFloatDecodingStrategy,
                keyDecodingStrategy: userInfoOptions.keyDecodingStrategy,
                userInfo: userInfoOptions.userInfo
            )

            let deeplink = try deeplinkType.notification(
                response: response,
                userInfoDecoder: userInfoDecoder,
                context: context
            )

            return resolveDeeplinkResult(
                deeplink: deeplink,
                scope: scope
            )
        } catch {
            return resolveDeeplinkResult(error: error)
        }
    }

    private func makeNotificationDeeplinkIfPossible(
        response: UNNotificationResponse,
        context: Any?
    ) throws -> DeeplinkStorage? {
        try makeDeeplinkIfPossible(of: AnyNotificationDeeplink.self) { scope, index in
            self.deeplinkTypes[scope]
                .flatMap { $0[index] as? AnyNotificationDeeplink.Type }
                .flatMap { deeplinkType in
                    self.makeNotificationDeeplinkIfPossible(
                        of: deeplinkType,
                        response: response,
                        context: context,
                        scope: scope
                    )
                }
        }
    }
    #endif

    #if canImport(UIKit) && os(iOS)
    private func makeShortcutDeeplinkIfPossible(
        of deeplinkType: AnyShortcutDeeplink.Type,
        shortcut: UIApplicationShortcutItem,
        context: Any?,
        scope: DeeplinkScope
    ) -> DeeplinkResult? {
        do {
            let userInfoOptions = try deeplinkType.shortcutUserInfoOptions(context: context)

            let userInfoDecoder = DictionaryDecoder(
                dateDecodingStrategy: userInfoOptions.dateDecodingStrategy,
                dataDecodingStrategy: userInfoOptions.dataDecodingStrategy,
                nonConformingFloatDecodingStrategy: userInfoOptions.nonConformingFloatDecodingStrategy,
                keyDecodingStrategy: userInfoOptions.keyDecodingStrategy,
                userInfo: userInfoOptions.userInfo
            )

            let deeplink = try deeplinkType.shortcut(
                shortcut,
                userInfoDecoder: userInfoDecoder,
                context: context
            )

            return resolveDeeplinkResult(
                deeplink: deeplink,
                scope: scope
            )
        } catch {
            return resolveDeeplinkResult(error: error)
        }
    }

    private func makeShortcutDeeplinkIfPossible(
        shortcut: UIApplicationShortcutItem,
        context: Any?,
        scope: DeeplinkScope
    ) throws -> DeeplinkStorage? {
        try makeDeeplinkIfPossible(of: AnyShortcutDeeplink.self) { scope, index in
            self.deeplinkTypes[scope]
                .flatMap { $0[index] as? AnyShortcutDeeplink.Type }
                .flatMap { deeplinkType in
                    self.makeShortcutDeeplinkIfPossible(
                        of: deeplinkType,
                        shortcut: shortcut,
                        context: context,
                        scope: scope
                    )
                }
        }
    }

    private func makeShortcutDeeplinkIfPossible(
        shortcut: UIApplicationShortcutItem,
        context: Any?
    ) throws -> DeeplinkStorage? {
        try deeplinkTypes.keys.lazy.compactMap { scope in
            try makeShortcutDeeplinkIfPossible(
                shortcut: shortcut,
                context: context,
                scope: scope
            )
        }
        .first { _ in true }
    }
    #endif

    public func canHandleURL(_ url: URL, context: Any?) -> Bool {
        let deeplink = try? makeURLDeeplinkIfPossible(
            url: url,
            context: context
        )

        return deeplink != nil
    }

    @discardableResult
    public func handleURL(_ url: URL, context: Any?) throws -> Bool {
        navigator.logInfo("Handling navigation for URL: \(url)")

        let deeplink = try makeURLDeeplinkIfPossible(
            url: url,
            context: context
        )

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
    public func canHandleNotification(response: UNNotificationResponse, context: Any?) -> Bool {
        let deeplink = try? makeNotificationDeeplinkIfPossible(
            response: response,
            context: context
        )

        return deeplink != nil
    }

    @discardableResult
    public func handleNotification(response: UNNotificationResponse, context: Any?) throws -> Bool {
        navigator.logInfo(
            """
            Handling navigation for notification:
            \(response.logDescription ?? "nil")
            """
        )

        let deeplink = try makeNotificationDeeplinkIfPossible(
            response: response,
            context: context
        )

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
    public func canHandleShortcut(_ shortcut: UIApplicationShortcutItem, context: Any?) -> Bool {
        let deeplink = try? makeShortcutDeeplinkIfPossible(
            shortcut: shortcut,
            context: context
        )

        return deeplink != nil
    }

    @discardableResult
    public func handleShortcut(_ shortcut: UIApplicationShortcutItem, context: Any?) throws -> Bool {
        navigator.logInfo(
            """
            Handling navigation for shortcut:
            \(shortcut.logDescription ?? "nil")
            """
        )

        let deeplink = try makeShortcutDeeplinkIfPossible(
            shortcut: shortcut,
            context: context
        )

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

    public func isActive(scope: DeeplinkScope) -> Bool {
        screens[scope] != nil
    }

    public func activate(screens: Any?, scope: DeeplinkScope) {
        self.screens[scope] = screens

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

    public func activate(screens: Any?) {
        deeplinkTypes.keys.forEach { scope in
            activate(screens: screens, scope: scope)
        }
    }

    public func deactivate(scope: DeeplinkScope) {
        self.screens.removeValue(forKey: scope)

        guard screens.isEmpty else {
            return
        }

        guard let applicationStateSubscription = applicationStateSubscription else {
            return
        }

        NotificationCenter
            .default
            .removeObserver(applicationStateSubscription)

        self.applicationStateSubscription = nil
    }

    public func deactivate() {
        deeplinkTypes.keys.forEach { scope in
            deactivate(scope: scope)
        }
    }
}
#endif
