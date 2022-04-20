import Foundation

public final class DefaultScreenRegistry: ScreenRegistry {

    private var observers: [ScreenObservationTarget: Set<ScreenObservationStorage>] = [:]

    public init() { }

    private func resolveObservers(for target: ScreenObservationTarget) -> Set<ScreenObservationStorage> {
        observers[target]?.filter { $0.observer != nil } ?? []
    }

    public func registerObserver(
        _ observer: AnyObject,
        for target: ScreenObservationTarget
    ) {
        observers[target] = resolveObservers(for: target).union([ScreenObservationStorage(observer)])
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
        for target: ScreenObservationTarget
    ) {
        observers[target] = resolveObservers(for: target).filter { $0.observer !== observer }
    }

    public func unregisterObserver<T: Screen>(
        _ observer: T.Observer,
        for screen: T
    ) where T.Observer: AnyObject {
        unregisterObserver(observer, for: .screen(key: screen.key))
    }

    public func observation<Observer>(
        of type: Observer.Type,
        for target: ScreenObservationTarget
    ) -> ScreenObservation<Observer> {
        ScreenObservation {
            let keyedObservers = self.resolveObservers(for: target)
            let unkeyedObservers = self.resolveObservers(for: .any)

            return keyedObservers
                .union(unkeyedObservers)
                .compactMap { $0.observer as? Observer }
        }
    }

    public func observation<T: Screen>(for screen: T) -> ScreenObservation<T.Observer> {
        observation(of: T.Observer.self, for: .screen(key: screen.key))
    }
}
