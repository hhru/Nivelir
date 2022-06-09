import Foundation

public protocol ScreenObservatory {

    func observeWeakly(
        by observer: ScreenObserver,
        where predicate: ScreenObserverPredicate
    )

    func observe(
        by observer: ScreenObserver,
        where predicate: ScreenObserverPredicate,
        weakly: Bool
    ) -> ScreenObserverToken

    func observe(
        by observer: ScreenObserver,
        where predicate: ScreenObserverPredicate
    ) -> ScreenObserverToken

    func observation<Observer>(
        of type: Observer.Type,
        iterator: ScreenIterator
    ) -> ScreenObservation<Observer>
}
