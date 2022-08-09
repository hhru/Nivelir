import Foundation

/// Token associated with the subscription lifecycle for the observer.
///
/// Once the token is removed from memory (deinit is called),
/// the subscription will be canceled and new notifications will not be received by the observer.
/// The subscription can also be canceled manually using the ``cancel()`` method.
public final class ScreenObserverToken {

    private let cancellation: () -> Void

    internal init(cancellation: @escaping () -> Void) {
        self.cancellation = cancellation
    }

    deinit {
        cancellation()
    }

    /// Unsubscribe the observer.
    public func cancel() {
        cancellation()
    }
}
