#if canImport(UIKit) && os(iOS)
import UIKit

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

    public func notificationOccurred(type: UINotificationFeedbackGenerator.FeedbackType) -> Self {
        then(ScreenNotificationOccurredAction(type: type))
    }
}
#endif
