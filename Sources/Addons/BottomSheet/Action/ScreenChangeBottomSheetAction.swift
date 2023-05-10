#if canImport(UIKit)
import UIKit

public struct ScreenChangeBottomSheetAction<Container: UIViewController>: ScreenAction {

    public typealias Changes = (_ bottomSheet: BottomSheetController) -> Void
    public typealias Output = Void

    public let animated: Bool
    public let changes: Changes

    public init(
        animated: Bool = true,
        changes: @escaping Changes
    ) {
        self.animated = animated
        self.changes = changes
    }

    public func perform(
        container: Container,
        navigator: ScreenNavigator,
        completion: @escaping Completion
    ) {
        navigator.logInfo("Changing bottom sheet of \(type(of: container))")

        guard let bottomSheet = container.bottomSheet else {
            return completion(.invalidBottomSheetContainer(container, for: self))
        }

        if animated {
            bottomSheet.animateChanges(changes)
        } else {
            changes(bottomSheet)
        }
    }
}

extension ScreenThenable where Current: UIViewController {

    public func changeBottomSheet(
        animated: Bool = true,
        changes: @escaping ScreenChangeBottomSheetAction.Changes
    ) -> Self {
        then(
            ScreenChangeBottomSheetAction<Current>(
                animated: animated,
                changes: changes
            )
        )
    }
}
#endif
