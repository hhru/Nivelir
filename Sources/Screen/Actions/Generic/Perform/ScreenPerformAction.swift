import Foundation

public struct ScreenPerformAction<Container: ScreenContainer, ContextType>: ScreenAction {
    
    public typealias Output = Void
    
    private let context: ContextType
    public init(context: ContextType) {
        self.context = context
    }
    
    public func perform(
        container: Container,
        navigator: ScreenNavigator,
        completion: @escaping Completion
    ) {
        guard let performableContainer = container as? AnyScreenPerformableContainer else {
            return completion(.containerTypeMismatch(container, type: ScreenRefreshableContainer.self, for: self))
        }
        
        performableContainer.perform(any: context, completion: completion)
    }
}

extension ScreenThenable {
    
    public func perfrorm<T>(context: T) -> Self {
        then(ScreenPerformAction(context: context))
    }
}
