#if canImport(UIKit)
import UIKit

#if canImport(UserNotifications)
import UserNotifications
#endif

#if canImport(PushKit)
import PushKit
#endif

/// The `DeeplinkManager` keeps track of the opening of ``Deeplink``.
///
/// The manager is the entry point when working with ``Deeplink``.
/// The types of ``Deeplink`` that the manager will handle are passed to the initializer.
///
/// The manager can handle ``Deeplink`` at any time,
/// but ``Deeplink`` will only start when the manager is activated, through the ``activate(screens:)`` method.
/// Until then, the manager will pend the last handled ``Deeplink`` for its performance.
///
/// The manager also keeps track of the state of the application,
/// and performs ``Deeplink`` only in the `UIApplication.State == .active` state.
///
/// If it is required to stop ``Deeplink`` handling, the manager can be deactivated through the ``deactivate()`` method.
///
/// **Scopes**
///
/// ``Deeplink`` can also be separated into scopes of application.
/// Each scope can be separately activated and deactivated as needed
/// using the ``activate(screens:scope:)`` and ``deactivate(scope:)`` methods, respectively.
/// For example, you can separate the deep links, which should work before and after the user onboarding,
/// and perform the activation and deactivation separately.
public final class DeeplinkManager: DeeplinkHandler {

    /// The types of deep links to handle, separated by scope of application.
    public let deeplinkTypes: [DeeplinkScope: [AnyDeeplink.Type]]

    /// Interceptors for ``Deeplink``.
    public let interceptors: [DeeplinkInterceptor]

    /// A navigator instance that performs navigation actions for ``Deeplink``.
    public let navigator: ScreenNavigator

    /// Activated scopes with erased type of screen factories.
    public private(set) var screens: [DeeplinkScope: Any?] = [:]

    /// A Boolean value indicating whether this manager is active.
    ///
    /// The value of this property is `true` if the manager has active scopes, and `false` if not.
    public var isActive: Bool {
        !screens.isEmpty
    }

    private var applicationStateSubscription: Any? {
        didSet { navigateIfPossible() }
    }

    private var pendingDeeplink: DeeplinkStorage? {
        didSet { navigateIfPossible() }
    }

    /// Creating a manager with types of ``Deeplink``, separated by scope.
    /// - Parameters:
    ///   - deeplinkTypes: The types of deep links to handle, separated by scope of application.
    ///   - interceptors: Interceptors for deep links.
    ///   - navigator: A navigator instance that performs navigation actions for deep links.
    public init(
        deeplinkTypes: [DeeplinkScope: [AnyDeeplink.Type]],
        interceptors: [DeeplinkInterceptor] = [],
        navigator: ScreenNavigator
    ) {
        self.deeplinkTypes = deeplinkTypes
        self.interceptors = interceptors
        self.navigator = navigator
    }

    /// Creating a manager with ``Deeplink`` types with default scope.
    /// - Parameters:
    ///   - deeplinkTypes: The types of deep links to handle.
    ///   - interceptors: Interceptors for deep links.
    ///   - navigator: A navigator instance that performs navigation actions for deep links.
    public convenience init(
        deeplinkTypes: [AnyDeeplink.Type],
        interceptors: [DeeplinkInterceptor] = [],
        navigator: ScreenNavigator
    ) {
        self.init(
            deeplinkTypes: [.default: deeplinkTypes],
            navigator: navigator
        )
    }

    private func performInterceptors(
        for deeplink: DeeplinkStorage,
        from index: Int = .zero,
        completion: @escaping DeeplinkInterceptor.Completion
    ) {
        guard index < interceptors.count else {
            return completion(.success)
        }

        interceptors[index].interceptDeeplink(
            deeplink.value,
            of: deeplink.type,
            navigator: navigator
        ) { result in
            switch result {
            case .success:
                self.performInterceptors(
                    for: deeplink,
                    from: index + 1,
                    completion: completion
                )

            case let .failure(error):
                completion(.failure(error))
            }
        }
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

        navigator.logInfo("Performing navigation for deeplink: \(deeplink.value)")

        pendingDeeplink = nil

        performInterceptors(for: deeplink) { result in
            do {
                try result.get()

                try deeplink.value.navigateIfPossible(
                    screens: screens,
                    navigator: self.navigator,
                    handler: self
                )
            } catch {
                self.navigator.logError(error)
            }
        }
    }

    private func handleDeeplinkIfPossible(_ deeplink: DeeplinkStorage?) -> Bool {
        if let deeplink {
            pendingDeeplink = deeplink
        }

        return deeplink != nil
    }

    private func resolveDeeplinkResult(
        deeplink: AnyDeeplink?,
        of type: DeeplinkType,
        scope: DeeplinkScope
    ) -> DeeplinkResult? {
        guard let deeplink else {
            return nil
        }

        let storage = DeeplinkStorage(
            value: deeplink,
            type: type,
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
                of: .url,
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
                of: .notification,
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

    #if canImport(PushKit) && os(iOS)
    private func makePushDeeplinkIfPossible(
        of deeplinkType: AnyPushDeeplink.Type,
        payload: PKPushPayload,
        context: Any?,
        scope: DeeplinkScope
    ) -> DeeplinkResult? {
        do {
            let dictionaryPayloadOptions = try deeplinkType.pushDictionaryPayloadOptions(context: context)

            let dictionaryPayloadDecoder = DictionaryDecoder(
                dateDecodingStrategy: dictionaryPayloadOptions.dateDecodingStrategy,
                dataDecodingStrategy: dictionaryPayloadOptions.dataDecodingStrategy,
                nonConformingFloatDecodingStrategy: dictionaryPayloadOptions.nonConformingFloatDecodingStrategy,
                keyDecodingStrategy: dictionaryPayloadOptions.keyDecodingStrategy,
                userInfo: dictionaryPayloadOptions.userInfo
            )

            let deeplink = try deeplinkType.push(
                payload: payload,
                dictionaryPayloadDecoder: dictionaryPayloadDecoder,
                context: context
            )

            return resolveDeeplinkResult(
                deeplink: deeplink,
                of: .push,
                scope: scope
            )
        } catch {
            return resolveDeeplinkResult(error: error)
        }
    }

    private func makePushDeeplinkIfPossible(
        payload: PKPushPayload,
        context: Any?
    ) throws -> DeeplinkStorage? {
        try makeDeeplinkIfPossible(of: AnyPushDeeplink.self) { scope, index in
            self.deeplinkTypes[scope]
                .flatMap { $0[index] as? AnyPushDeeplink.Type }
                .flatMap { deeplinkType in
                    self.makePushDeeplinkIfPossible(
                        of: deeplinkType,
                        payload: payload,
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
                of: .shortcut,
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

    /// Handle the URL by a suitable ``URLDeeplink`` and perform navigation, if possible.
    ///
    /// This method does not raise an exception. Instead the error is logged through the navigator.
    /// - Parameters:
    ///   - url: A URL Scheme or Universal Link from `UIApplicationDelegate` or `UIWindowSceneDelegate`.
    ///
    ///   - context: Additional context for checking and creating ``URLDeeplink``.
    ///   Must match the context type of ``URLDeeplink/URLContext``.
    ///
    /// - Returns: `false` if there is no suitable ``URLDeeplink`` to handle the URL; otherwise `true`.
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

    /// Handle the Notification by a suitable ``NotificationDeeplink`` and perform navigation, if possible.
    ///
    /// This method does not raise an exception. Instead the error is logged through the navigator.
    /// - Parameters:
    ///   - response: The user’s response to an actionable notification.
    ///   - context: Additional context for checking and creating ``NotificationDeeplink``.
    ///   Must match the context type of ``NotificationDeeplink/NotificationContext``.
    /// - Returns: `false` if there is no suitable ``NotificationDeeplink`` to handle the Notification;
    /// otherwise `true`.
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

    #if canImport(PushKit) && os(iOS)
    public func canHandlePush(payload: PKPushPayload, context: Any?) -> Bool {
        let deeplink = try? makePushDeeplinkIfPossible(
            payload: payload,
            context: context
        )

        return deeplink != nil
    }

    @discardableResult
    public func handlePush(payload: PKPushPayload, context: Any?) throws -> Bool {
        navigator.logInfo(
            """
            Handling navigation for notification:
            \(payload.logDescription ?? "nil")
            """
        )

        let deeplink = try makePushDeeplinkIfPossible(
            payload: payload,
            context: context
        )

        return handleDeeplinkIfPossible(deeplink)
    }

    /// Handle the Push by a suitable ``PushDeeplink`` and perform navigation, if possible.
    ///
    /// This method does not raise an exception. Instead the error is logged through the navigator.
    /// - Parameters:
    ///   - payload: An object that contains information about a received PushKit notification.
    ///   - context: Additional context for checking and creating ``PushDeeplink``.
    ///   Must match the context type of ``PushDeeplink/PushContext``.
    /// - Returns: `false` if there is no suitable ``PushDeeplink`` to handle the Push;
    /// otherwise `true`.
    @discardableResult
    public func handlePushIfPossible(payload: PKPushPayload, context: Any?) -> Bool {
        do {
            return try handlePush(payload: payload, context: context)
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

    /// Handle the Notification by a suitable ``NotificationDeeplink`` and perform navigation, if possible.
    ///
    /// This method does not raise an exception. Instead the error is logged through the navigator.
    /// - Parameters:
    ///   - shortcut: An application shortcut item, also called a *Home screen dynamic quick action*,
    ///   that specifies a user-initiated action for your app.
    ///
    ///   - context: Additional context for checking and creating ``ShortcutDeeplink``.
    ///   Must match the context type of ``ShortcutDeeplink/ShortcutContext``.
    ///
    /// - Returns: `false` if there is no suitable ``ShortcutDeeplink`` to handle the Shortcut App;
    /// otherwise `true`.
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

    /// Returns a Boolean value indicating whether the specified `scope` is active.
    /// - Parameter scope: Scope for checking.
    /// - Returns: The return value is `true` if the specified `scope` is active, and `false` if it is not.
    public func isActive(scope: DeeplinkScope) -> Bool {
        screens[scope] != nil
    }

    /// Activates the scope with the screen factory.
    ///
    /// After activation, the manager will be able to handle the ``Deeplink`` included in the specified `scope`
    /// and perform a pending one, if any.
    /// - Parameters:
    ///   - screens: A screen factory used to navigate deep links.
    ///   The instance type must match the type of the ``Deeplink/Screens`` to being handled.
    ///   - scope: Activatable scope of deep links.
    public func activate(screens: Any?, scope: DeeplinkScope) {
        self.screens[scope] = screens

        guard applicationStateSubscription == nil else {
            return navigateIfPossible()
        }

        applicationStateSubscription = NotificationCenter.default.addObserver(
            forName: UIApplication.didBecomeActiveNotification,
            object: nil,
            queue: nil
        ) { [weak self] _ in
            self?.navigateIfPossible()
        }
    }

    /// Activates all scopes with the screen factory.
    ///
    /// After activation, the manager will be able to handle all deep links and perform a pending one, if any.
    /// - Parameter screens: A screen factory used to navigate deep links.
    /// The instance type must match the type of the ``Deeplink/Screens`` to being handled.
    public func activate(screens: Any?) {
        deeplinkTypes.keys.forEach { scope in
            activate(screens: screens, scope: scope)
        }
    }

    /// Deactivates the scope of deep links.
    ///
    /// After deactivation, the manager will not handle ``Deeplink`` within the specified `scope`.
    /// The manager will pend the last handled ``Deeplink`` for its performance after activation.
    /// - Parameter scope: Deactivatable scope of deep links.
    public func deactivate(scope: DeeplinkScope) {
        self.screens.removeValue(forKey: scope)

        guard screens.isEmpty else {
            return
        }

        guard let applicationStateSubscription else {
            return
        }

        NotificationCenter
            .default
            .removeObserver(applicationStateSubscription)

        self.applicationStateSubscription = nil
    }

    /// Deactivates all scopes.
    ///
    /// After deactivation, the manager will not handle all deep links.
    /// The manager will pend the last handled ``Deeplink`` for its performance after activation.
    public func deactivate() {
        deeplinkTypes.keys.forEach { scope in
            deactivate(scope: scope)
        }
    }
}
#endif
