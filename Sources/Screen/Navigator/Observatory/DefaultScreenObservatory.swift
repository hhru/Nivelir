import Foundation

public final class DefaultScreenObservatory: ScreenObservatory {

    private var observers: [ScreenObservationTarget: [ScreenObservationStorage]] = [:]

    public init() { }

    public func registerObserver(_ observer: AnyObject, for target: ScreenObservationTarget) {
        let targetObservers = observers[target]?
            .filter { $0.value != nil }
            .filter { $0.value !== observer } ?? []

        observers[target] = targetObservers.appending(ScreenObservationStorage(observer))
    }

    public func registerObserver<T: Screen>(
        _ observer: T.Observer,
        for screen: T
    ) where T.Observer: AnyObject {
        registerObserver(observer, for: .screen(key: screen.key))
    }

    public func unregisterObserver(_ observer: AnyObject, for target: ScreenObservationTarget) {
        let targetObservers = observers[target]?
            .filter { $0.value != nil }
            .filter { $0.value !== observer }

        observers[target] = targetObservers.isEmptyOrNil
            ? nil
            : targetObservers
    }

    public func unregisterObserver<T: Screen>(
        _ observer: T.Observer,
        for screen: T
    ) where T.Observer: AnyObject {
        unregisterObserver(observer, for: .screen(key: screen.key))
    }

    public func unregisterObserver(_ observer: AnyObject) {
        for target in observers.keys {
            unregisterObserver(observer, for: target)
        }
    }

    public func observation<Observer>(
        of type: Observer.Type,
        for target: ScreenObservationTarget
    ) -> ScreenObservation<Observer> {
        ScreenObservation(target: target) {
            let targetObservers = self.observers[target] ?? []
            let anyObservers = self.observers[.any] ?? []

            let observers = anyObservers.reduce(into: targetObservers) { observers, observer in
                if !observers.contains(where: { $0.value === observer.value }) {
                    observers.append(observer)
                }
            }

            return observers.compactMap { $0.value as? Observer }
        }
    }

    public func observation<T: Screen>(for screen: T) -> ScreenObservation<T.Observer> {
        observation(of: T.Observer.self, for: .screen(key: screen.key))
    }
}
