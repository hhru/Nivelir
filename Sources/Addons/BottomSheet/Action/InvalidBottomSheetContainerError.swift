import Foundation

public struct InvalidBottomSheetContainerError: ScreenError {

    public let description: String

    public init(container: ScreenContainer, for trigger: Any) {
        description = """
        The container \(container) is not presented as a bottom sheet for:
          \(trigger)
        """
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
