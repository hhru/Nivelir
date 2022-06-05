import Foundation

public struct ScreenPerformableContainerError: Error, CustomStringConvertible {
    public var description: String {
        """
        The type of the context \(context ?? "nil") does not match the expected type \(type) for:
          \(trigger)
        """
    }
    
    /// Context instance.
    public let context: Any?
    
    /// Expected context type.
    public let type: Any.Type
    
    /// The deeplink that caused the error.
    public let trigger: Any
    
    /// Creates an error.
    ///
    /// - Parameters:
    ///   - context: Context instance.
    ///   - type: Expected context type.
    ///   - trigger: The deeplink that caused the error.
    public init(
        context: Any?,
        type: Any.Type,
        for trigger: Any
    ) {
        self.context = context
        self.type = type
        self.trigger = trigger
    }
}
