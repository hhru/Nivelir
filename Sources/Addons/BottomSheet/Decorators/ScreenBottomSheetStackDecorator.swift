#if canImport(UIKit)
import UIKit

public struct ScreenBottomSheetStackDecorator<
    Container: UIViewController,
    Output: BottomSheetStackController
>: ScreenDecorator {

    public let bottomSheet: BottomSheet

    public var payload: Any? {
        nil
    }

    public var description: String {
        "ScreenBottomSheetStackDecorator"
    }

    public init(bottomSheet: BottomSheet) {
        self.bottomSheet = bottomSheet
    }

    public func build<Wrapped: Screen>(
        screen: Wrapped,
        navigator: ScreenNavigator
    ) -> Output where Wrapped.Container == Container {
        screen
            .withStackContainer(of: Output.self)
            .withBottomSheet(bottomSheet)
            .build(navigator: navigator)
    }
}

extension Screen where Container: UIViewController {

    public func withBottomSheetStack<Output: BottomSheetStackController>(
        _ bottomSheet: BottomSheet,
        of type: Output.Type
    ) -> AnyScreen<Output> {
        decorated(by: ScreenBottomSheetStackDecorator<Container, Output>(bottomSheet: bottomSheet))
    }

    public func withBottomSheetStack(_ bottomSheet: BottomSheet) -> AnyScreen<BottomSheetStackController> {
        withBottomSheetStack(bottomSheet, of: BottomSheetStackController.self)
    }
}
#endif
