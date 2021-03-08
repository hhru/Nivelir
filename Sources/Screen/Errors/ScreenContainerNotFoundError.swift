import Foundation

public struct ScreenContainerNotFoundError<Container: ScreenContainer>: ScreenError {

    public var description: String {
        """
        No screen container of \(Container.self) type found for:
          \(trigger)
        """
    }

    public let trigger: Any

    public init(for trigger: Any) {
        self.trigger = trigger
    }
}
