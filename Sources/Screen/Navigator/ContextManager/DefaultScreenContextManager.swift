import Foundation

public final class DefaultScreenContextManager: ScreenContextManager {

    private var contexts: [ScreenKey?: [ScreenContextStorage]] = [:]

    public init() { }

    private func resolveContexts(for key: ScreenKey?) -> [ScreenContextStorage] {
        contexts[key]?.filter { $0.context != nil } ?? []
    }

    private func registerContext(
        _ context: AnyObject,
        for key: ScreenKey?,
        scope: ScreenContextScope
    ) {
        contexts[key] = resolveContexts(for: key).appending(scope.makeStorage(for: context))
    }

    public func registerWeakContext(_ context: AnyObject, for key: ScreenKey) {
        registerContext(context, for: key, scope: ScreenContextWeakScope.default)
    }

    public func registerWeakContext<T: Screen>(_ context: AnyObject, for screen: T) {
        registerWeakContext(context, for: screen.key)
    }

    public func registerWeakContext(_ context: AnyObject) {
        registerContext(context, for: nil, scope: ScreenContextWeakScope.default)
    }

    public func registerContext(_ context: AnyObject, for key: ScreenKey) {
        registerContext(context, for: key, scope: ScreenContextSharedScope.default)
    }

    public func registerContext<T: Screen>(_ context: AnyObject, for screen: T) {
        registerContext(context, for: screen.key)
    }

    public func registerContext(_ context: AnyObject) {
        registerContext(context, for: nil, scope: ScreenContextSharedScope.default)
    }

    public func unregisterContext(_ context: AnyObject, for key: ScreenKey) {
        contexts[key] = resolveContexts(for: key).removingAll { $0.context === context }
    }

    public func unregisterContext<T: Screen>(_ context: AnyObject, for screen: T) {
        unregisterContext(context, for: screen.key)
    }

    public func unregisterContext(_ context: AnyObject) {
        contexts[nil] = resolveContexts(for: nil).removingAll { $0.context === context }
    }

    public func context<Context>(
        of type: Context.Type,
        for key: ScreenKey
    ) -> ScreenContext<Context> {
        ScreenContext {
            let keyedContexts = self.resolveContexts(for: key).compactMap { context in
                context.context as? Context
            }

            let unkeyedContexts = self.resolveContexts(for: nil).compactMap { context in
                context.context as? Context
            }

            return keyedContexts.appending(contentsOf: unkeyedContexts)
        }
    }

    public func context<T: Screen>(for screen: T) -> ScreenContext<T.Context> {
        context(of: T.Context.self, for: screen.key)
    }

    public func context<Context>(of type: Context.Type) -> ScreenContext<Context> {
        ScreenContext {
            self.resolveContexts(for: nil).compactMap { context in
                context.context as? Context
            }
        }
    }
}
