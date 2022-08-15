#if canImport(UIKit) && os(iOS)
import UIKit

/// Action that creates haptics to communicate successes,
/// failures, and warnings using `UINotificationFeedbackGenerator`.
public struct ScreenNotificationOccurredAction<Container: ScreenContainer>: ScreenAction {

    public typealias Output = Void

    private let type: UINotificationFeedbackGenerator.FeedbackType

    public init(type: UINotificationFeedbackGenerator.FeedbackType) {
        self.type = type
    }

    public func perform(
        container: Container,
        navigator: ScreenNavigator,
        completion: @escaping Completion
    ) {
        let generator = UINotificationFeedbackGenerator()

        generator.notificationOccurred(type)

        completion(.success)
    }
}

extension ScreenThenable {

    /// Triggers notification feedback.
    ///
    /// This method tells the `UINotificationFeedbackGenerator` that a task or action has succeeded,
    /// failed, or produced a warning.
    /// In response, the generator may play the appropriate haptics,
    /// based on the provided `UINotificationFeedbackGenerator.FeedbackType` value.
    ///
    /// For information on setting up a feedback generator,
    /// see [Using feedback generators](https://developer.apple.com/documentation/uikit/uifeedbackgenerator#2555399).
    ///
    /// - Parameter type: The type of notification feedback.
    /// For a list of valid notification types, see the `UINotificationFeedbackGenerator.FeedbackType` enumeration.
    ///
    /// - Returns: An instance containing the new action.
    public func notificationOccurred(type: UINotificationFeedbackGenerator.FeedbackType) -> Self {
        then(ScreenNotificationOccurredAction(type: type))
    }
}
#endif
