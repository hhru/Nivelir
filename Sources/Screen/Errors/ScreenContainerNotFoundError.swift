import Foundation

public struct ScreenContainerNotFoundError: ScreenError {

    public var description: String {
        """
        No container of \(type) type found for:
          \(trigger)
        """
    }

    public let type: Any.Type
    public let trigger: Any

    public init(type: Any.Type, for trigger: Any) {
        self.type = type
        self.trigger = trigger
    }
}

extension Result where Failure == Error {

    internal static func containerNotFound(type: Any.Type, for trigger: Any) -> Self {
        .failure(
            ScreenContainerNotFoundError(
                type: type,
                for: trigger
            )
        )
    }
}
