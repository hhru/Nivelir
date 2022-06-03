import Foundation

public final class ScreenObserverToken {

    private let cancellation: () -> Void

    internal init(cancellation: @escaping () -> Void) {
        self.cancellation = cancellation
    }

    deinit {
        cancellation()
    }

    public func cancel() {
        cancellation()
    }
}
