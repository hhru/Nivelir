#if canImport(UIKit) && os(iOS)
import UIKit

/// Action that creates haptics to simulate physical impacts using `UIImpactFeedbackGenerator`.
public struct ScreenImpactOccurredAction<Container: ScreenContainer>: ScreenAction {

    public typealias Output = Void

    private let style: UIImpactFeedbackGenerator.FeedbackStyle?
    private let intensity: CGFloat?

    public init(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        self.style = style
        self.intensity = nil
    }

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

        if let intensity {
            generator.impactOccurred(intensity: intensity)
        } else {
            generator.impactOccurred()
        }

        completion(.success)
    }
}

extension ScreenThenable {

    /// Triggers impact feedback.
    ///
    /// This method tells the `UIImpactFeedbackGenerator` that an impact has occurred.
    /// In response, the generator may play the appropriate haptics based on the `style` value passed to the parameters.
    ///
    /// For information on setting up a feedback generator,
    /// see [Using feedback generators](https://developer.apple.com/documentation/uikit/uifeedbackgenerator#2555399).
    ///
    /// - Parameter style: A value representing the mass of the colliding objects.
    /// For a list of valid feedback styles, see the `UIImpactFeedbackGenerator.FeedbackStyle` enumeration.
    /// - Returns: An instance containing the new action.
    public func impactOccurred(style: UIImpactFeedbackGenerator.FeedbackStyle) -> Self {
        then(ScreenImpactOccurredAction(style: style))
    }

    /// Triggers impact feedback with a specific intensity.
    ///
    /// - Parameter intensity: A CGFloat value between 0.0 and 1.0.
    /// - Returns: An instance containing the new action.
    public func impactOccurred(intensity: CGFloat) -> Self {
        then(ScreenImpactOccurredAction(intensity: intensity))
    }
}
#endif
