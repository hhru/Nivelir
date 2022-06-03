import Foundation

internal final class ScreenObserverSharedStorage: ScreenObserverStorage {

    private let observer: ScreenObserver

    internal let predicate: ScreenObserverPredicate

    internal var value: ScreenObserver? {
        observer
    }

    internal init(
        observer: ScreenObserver,
        predicate: ScreenObserverPredicate
    ) {
        self.observer = observer
        self.predicate = predicate
    }
}
