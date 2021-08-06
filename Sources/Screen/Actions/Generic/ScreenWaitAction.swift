import Foundation

/// Waits for a given time interval.
public struct ScreenWaitAction<Container: ScreenContainer>: ScreenAction {

    /// The type of value returned by the action.
    public typealias Output = Void

    /// Waiting time in seconds.
    public let duration: TimeInterval

    public init(duration: TimeInterval) {
        self.duration = duration
    }

    public func perform(
        container: Container,
        navigator: ScreenNavigator,
        completion: @escaping Completion
    ) {
        navigator.logInfo("Waiting for \(duration) seconds")

        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            completion(.success)
        }
    }
}

extension ScreenThenable {

    /// Waits for a given time interval.
    ///
    /// Usage examples
    /// ==============
    ///
    /// - Shows an error message and dismisses it after 3 seconds:
    ///
    /// ``` swift
    /// screenNavigator.navigate(from: self) { route in
    ///     route
    ///         .showAlert(.somethingWentWrong)
    ///         .wait(for: 3.0)
    ///         .dismiss()
    /// }
    /// ```
    ///
    /// - Parameter duration: Waiting time in seconds.
    /// - Returns: An instance containing the new action.
    public func wait(for duration: TimeInterval) -> Self {
        then(ScreenWaitAction(duration: duration))
    }
}
