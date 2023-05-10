import Foundation

public struct InvalidBottomSheetContainerError: ScreenError {

    public var description: String {
        """
        The container \(container) is not presented as a bottom sheet for:
          \(trigger)
        """
    }

    public let container: ScreenContainer
    public let trigger: Any

    public init(container: ScreenContainer, for trigger: Any) {
        self.container = container
        self.trigger = trigger
    }
}

extension Result where Failure == Error {

    internal static func invalidBottomSheetContainer(
        _ container: ScreenContainer,
        for trigger: Any
    ) -> Self {
        .failure(
            InvalidBottomSheetContainerError(
                container: container,
                for: trigger
            )
        )
    }
}
