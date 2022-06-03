import Foundation

internal final class ScreenObserverWeakStorage: ScreenObserverStorage {

    internal typealias Observer = ScreenObserver & AnyObject

    private weak var observer: Observer?

    internal let predicate: ScreenObserverPredicate

    internal var value: ScreenObserver? {
        observer
    }

    internal init(
        observer: Observer,
        predicate: ScreenObserverPredicate
    ) {
        self.observer = observer
        self.predicate = predicate
    }
}
