#if canImport(UIKit) && os(iOS)
import UIKit

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

    public func selectionChanged() -> Self {
        then(ScreenSelectionChangedAction())
    }
}
#endif
