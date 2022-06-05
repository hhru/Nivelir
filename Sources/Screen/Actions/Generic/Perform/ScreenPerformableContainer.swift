import Foundation

public protocol AnyScreenPerformableContainer: ScreenContainer {
    func perform(any context: Any?, completion: @escaping (Result<Void, Error>) -> Void)
}

public protocol ScreenPerformableContainer: AnyScreenPerformableContainer {
    associatedtype ContextType
    func perform(context: ContextType, completion: @escaping (Result<Void, Error>) -> Void)
}

extension ScreenPerformableContainer {
    public func perform(any context: Any?, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let resolved = try resolveContext(context)
            self.perform(context: resolved, completion: completion)
        } catch {
            completion(.failure(error))
        }
    }
    
    private func resolveContext(_ context: Any?) throws -> ContextType {
        guard let urlContext = context as? ContextType else {
            throw ScreenPerformableContainerError(
                context: context,
                type: ContextType.self,
                for: self
            )
        }
        
        return urlContext
    }
}

