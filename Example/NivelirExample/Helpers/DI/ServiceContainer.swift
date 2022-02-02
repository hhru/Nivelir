import Foundation

final class ServiceContainer {

    private var services: [ServiceKey: ServiceStorage] = [:]
    private let lock = NSRecursiveLock()

    func resolve<Service>(
        name: String = #function,
        traits: [AnyHashable] = [],
        using factory: () -> Service,
        at scope: ServiceScope
    ) -> Service {
        lock.lock()

        defer {
            lock.unlock()
        }

        let serviceKey = ServiceKey(
            type: Service.self,
            name: name,
            traits: traits
        )

        if let service = services[serviceKey]?.service.flatMap({ $0 as? Service }) {
            return service
        }

        let service = factory()
        let storage = scope.storage(for: service)

        services[serviceKey] = storage

        return service
    }

    func shared<Service>(
        name: String = #function,
        traits: [AnyHashable] = [],
        using factory: () -> Service
    ) -> Service {
        resolve(
            name: name,
            traits: traits,
            using: factory,
            at: ServiceSharedScope.default
        )
    }
}
