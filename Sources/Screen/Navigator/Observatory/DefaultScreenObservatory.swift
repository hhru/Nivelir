import Foundation

public final class DefaultScreenObservatory: ScreenObservatory {

    private var observers: [ScreenObserverStorage] = []

    public init() { }

    private func updateObservers(appending storage: ScreenObserverStorage) {
        observers = observers
            .filter { $0.value != nil }
            .appending(storage)
    }

    private func updateObservers(removing storage: ScreenObserverStorage) {
        observers = observers
            .filter { $0.value != nil }
            .filter { $0 !== storage }
    }

    public func observeWeakly(
        by observer: ScreenObserver,
        where predicate: ScreenObserverPredicate
    ) {
        let storage = ScreenObserverWeakStorage(
            observer: observer,
            predicate: predicate
        )

        updateObservers(appending: storage)
    }

    public func observe(
        by observer: ScreenObserver,
        where predicate: ScreenObserverPredicate,
        weakly: Bool
    ) -> ScreenObserverToken {
        let storage: ScreenObserverStorage

        if weakly {
            storage = ScreenObserverWeakStorage(
                observer: observer,
                predicate: predicate
            )
        } else {
            storage = ScreenObserverSharedStorage(
                observer: observer,
                predicate: predicate
            )
        }

        updateObservers(appending: storage)

        return ScreenObserverToken { [weak self, weak storage] in
            if let self = self, let storage = storage {
                self.updateObservers(removing: storage)
            }
        }
    }

    public func observe(
        by observer: ScreenObserver,
        where predicate: ScreenObserverPredicate
    ) -> ScreenObserverToken {
        observe(by: observer, where: predicate, weakly: false)
    }

    public func observation<Observer>(
        of type: Observer.Type,
        iterator: ScreenIterator
    ) -> ScreenObservation<Observer> {
        ScreenObservation { [weak self] container in
            self?
                .observers
                .lazy
                .map { ($0.predicate, $0.value) }
                .compactMap { predicate, observer in
                    observer.flatMap { observer in
                        predicate.filterObserver(
                            observer,
                            for: container,
                            using: iterator
                        ) ? observer : nil
                    }
                }
                .unique { $0 === $1 }
                .compactMap { $0 as? Observer } ?? []
        }
    }
}
