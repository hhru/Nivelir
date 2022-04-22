import Foundation

public struct ScreenObservation<Observer> {

    public let target: ScreenObservationTarget
    private let observers: () -> [Observer]

    internal init(
        target: ScreenObservationTarget,
        observers: @escaping () -> [Observer]
    ) {
        self.target = target
        self.observers = observers
    }

    public func notify(_ body: (_ observer: Observer) throws -> Void) rethrows {
        try observers().forEach(body)
    }

    public func callAsFunction(_ body: (_ observer: Observer) throws -> Void) rethrows {
        try notify(body)
    }
}
