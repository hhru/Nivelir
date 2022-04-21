import Foundation

public struct ScreenObserver<Observer> {

    public let target: ScreenObserverTarget
    private let observers: () -> [Observer]

    internal init(
        target: ScreenObserverTarget,
        observers: @escaping () -> [Observer]
    ) {
        self.target = target
        self.observers = observers
    }

    public func post(_ body: (_ observer: Observer) throws -> Void) rethrows {
        try observers().forEach(body)
    }
}
