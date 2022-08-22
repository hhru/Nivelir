#if canImport(UIKit) && os(iOS)
import UIKit

/// Action that creates haptics to indicate a change in selection using `UISelectionFeedbackGenerator`.
public struct ScreenSelectionChangedAction<Container: ScreenContainer>: ScreenAction {

    public typealias Output = Void

    public init() { }

    public func perform(
        container: Container,
        navigator: ScreenNavigator,
        completion: @escaping Completion
    ) {
        let generator = UISelectionFeedbackGenerator()

        generator.selectionChanged()

        completion(.success)
    }
}

extension ScreenThenable {

    /// Triggers selection feedback.
    ///
    /// This method tells the `UISelectionFeedbackGenerator` that the user has changed a selection.
    /// In response, the generator may play the appropriate haptics.
    /// Don’t use this feedback when the user makes or confirms a selection;
    /// use it only when the selection changes.
    ///
    /// For information on setting up a feedback generator,
    /// see [Using feedback generators](https://developer.apple.com/documentation/uikit/uifeedbackgenerator#2555399).
    ///
    /// - Returns: An instance containing the new action.
    public func selectionChanged() -> Self {
        then(ScreenSelectionChangedAction())
    }
}
#endif
