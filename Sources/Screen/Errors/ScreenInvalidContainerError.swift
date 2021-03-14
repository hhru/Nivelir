import Foundation

public struct ScreenInvalidContainerError: ScreenError {

    public var description: String {
        """
        Could not cast container \(container) to \(type) for:
          \(trigger)
        """
    }

    public let container: ScreenContainer
    public let type: Any.Type
    public let trigger: Any

    public init(container: ScreenContainer, type: Any.Type, for trigger: Any) {
        self.container = container
        self.type = type
        self.trigger = trigger
    }
}

extension Result where Failure == Error {

    internal static func invalidContainer(
        _ container: ScreenContainer,
        type: Any.Type,
        for trigger: Any
    ) -> Self {
        .failure(
            ScreenInvalidContainerError(
                container: container,
                type: type,
                for: trigger
            )
        )
    }
}
