#if canImport(UIKit)
import UIKit

public struct ScreenBottomSheetDecorator<Container: UIViewController>: ScreenDecorator {

    private let bottomSheetController: BottomSheetController

    public let bottomSheet: BottomSheet

    public var payload: Any? {
        bottomSheetController
    }

    public let description: String

    public init(bottomSheet: BottomSheet) {
        self.bottomSheet = bottomSheet
        self.bottomSheetController = BottomSheetController(bottomSheet: bottomSheet)
        description = "BottomSheetDecorator"
    }

    public func build<Wrapped: Screen>(
        screen: Wrapped,
        navigator: ScreenNavigator
    ) -> Container where Wrapped.Container == Container {
        let container = screen.build(navigator: navigator)

        container.modalPresentationStyle = .custom
        container.transitioningDelegate = bottomSheetController

        return container
    }
}

extension Screen where Container: UIViewController {

    @MainActor
    public func withBottomSheet(_ bottomSheet: BottomSheet) -> AnyScreen<Container> {
        decorated(by: ScreenBottomSheetDecorator(bottomSheet: bottomSheet))
    }
}
#endif
