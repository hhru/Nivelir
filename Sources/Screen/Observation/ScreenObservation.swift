import Foundation

public class ScreenObservation<Observer> {

    private var container: ScreenContainerStorage?
    private let observers: (_ container: ScreenContainer?) -> [Observer]

    internal init(observers: @escaping (_ container: ScreenContainer?) -> [Observer]) {
        self.observers = observers
    }

    internal func associate(with container: ScreenContainer) {
        if let container = container as? (ScreenContainer & AnyObject) {
            self.container = ScreenContainerWeakStorage(container)
        } else {
            self.container = ScreenContainerSharedStorage(container)
        }
    }

    public func notify(_ body: (_ observer: Observer) throws -> Void) rethrows {
        try observers(container?.value).forEach(body)
    }

    public func callAsFunction(_ body: (_ observer: Observer) throws -> Void) rethrows {
        try notify(body)
    }
}
