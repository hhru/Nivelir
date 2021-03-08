import Foundation

public struct ScreenInvalidContainerError<Container: ScreenContainer>: ScreenError {

    public var description: String {
        """
        Could not cast screen container to \(Container.self) for:
          \(trigger)
        """
    }

    public let trigger: Any

    public init(for trigger: Any) {
        self.trigger = trigger
    }
}
