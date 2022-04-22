import Foundation

public final class DefaultScreenRegistry: ScreenRegistry {

    private var observers: [ScreenObserverTarget: Set<ScreenObserverStorage>] = [:]

    public init() { }

    private func resolveObservers(for target: ScreenObserverTarget) -> Set<ScreenObserverStorage> {
        observers[target]?.filter { $0.observer != nil } ?? []
    }

    public func registerObserver(
        _ observer: AnyObject,
        for target: ScreenObserverTarget
    ) {
        observers[target] = resolveObservers(for: target).union([ScreenObserverStorage(observer)])
    }

    public func registerObserver<T: Screen>(
        _ observer: T.Observer,
        for screen: T
    ) where T.Observer: AnyObject {
        registerObserver(observer, for: .screen(key: screen.key))
    }

    public func unregisterObserver(_ observer: AnyObject) {
        for target in observers.keys {
            observers[target] = resolveObservers(for: target).filter { $0.observer !== observer }
        }
    }

    public func unregisterObserver(
        _ observer: AnyObject,
        for target: ScreenObserverTarget
    ) {
        observers[target] = resolveObservers(for: target).filter { $0.observer !== observer }
    }

    public func unregisterObserver<T: Screen>(
        _ observer: T.Observer,
        for screen: T
    ) where T.Observer: AnyObject {
        unregisterObserver(observer, for: .screen(key: screen.key))
    }

    public func observer<Observer>(
        of type: Observer.Type,
        for target: ScreenObserverTarget
    ) -> ScreenObserver<Observer> {
        ScreenObserver(target: target) {
            let keyedObservers = self.resolveObservers(for: target)
            let unkeyedObservers = self.resolveObservers(for: .any)

            return keyedObservers
                .union(unkeyedObservers)
                .compactMap { $0.observer as? Observer }
        }
    }

    public func observer<T: Screen>(for screen: T) -> ScreenObserver<T.Observer> {
        observer(of: T.Observer.self, for: .screen(key: screen.key))
    }
}
