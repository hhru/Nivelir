import Foundation

public struct ScreenObservation<Observer> {

    private let observers: () -> [Observer]

    internal init(observers: @escaping () -> [Observer]) {
        self.observers = observers
    }

    public func post(_ body: (_ observer: Observer) throws -> Void) rethrows {
        try observers().forEach(body)
    }
}
