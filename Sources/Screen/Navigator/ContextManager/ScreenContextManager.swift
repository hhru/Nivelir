import Foundation

public protocol ScreenContextManager {

    func registerWeakContext(_ context: AnyObject, for key: ScreenKey)
    func registerWeakContext<T: Screen>(_ context: AnyObject, for screen: T)
    func registerWeakContext(_ context: AnyObject)

    func registerContext(_ context: AnyObject, for key: ScreenKey)
    func registerContext<T: Screen>(_ context: AnyObject, for screen: T)
    func registerContext(_ context: AnyObject)

    func unregisterContext(_ context: AnyObject, for key: ScreenKey)
    func unregisterContext<T: Screen>(_ context: AnyObject, for screen: T)
    func unregisterContext(_ context: AnyObject)

    func context<Context>(of type: Context.Type, for key: ScreenKey) -> ScreenContext<Context>
    func context<T: Screen>(for screen: T) -> ScreenContext<T.Context>
    func context<Context>(of type: Context.Type) -> ScreenContext<Context>
}
