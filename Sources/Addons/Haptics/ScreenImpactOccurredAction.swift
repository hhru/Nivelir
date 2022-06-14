#if canImport(UIKit) && os(iOS)
import UIKit

public struct ScreenImpactOccurredAction<Container: ScreenContainer>: ScreenAction {

    public typealias Output = Void

    private let style: UIImpactFeedbackGenerator.FeedbackStyle?
    private let intensity: CGFloat?

    public init(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        self.style = style
        self.intensity = nil
    }

    @available(iOS 13.0, *)
    public init(intensity: CGFloat) {
        self.style = nil
        self.intensity = intensity
    }

    public func perform(
        container: Container,
        navigator: ScreenNavigator,
        completion: @escaping Completion
    ) {
        let generator = style.map { style in
            UIImpactFeedbackGenerator(style: style)
        } ?? UIImpactFeedbackGenerator()

        if #available(iOS 13.0, *), let intensity = intensity {
            generator.impactOccurred(intensity: intensity)
        } else {
            generator.impactOccurred()
        }

        completion(.success)
    }
}

extension ScreenThenable {

    public func impactOccurred(style: UIImpactFeedbackGenerator.FeedbackStyle) -> Self {
        then(ScreenImpactOccurredAction(style: style))
    }

    @available(iOS 13.0, *)
    public func impactOccurred(intensity: CGFloat) -> Self {
        then(ScreenImpactOccurredAction(intensity: intensity))
    }
}
#endif
