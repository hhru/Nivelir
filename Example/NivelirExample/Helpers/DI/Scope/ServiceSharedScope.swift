import Foundation

struct ServiceSharedScope: ServiceScope {

    static let `default` = Self()

    private init() { }

    func storage(for service: Any) -> ServiceStorage {
        ServiceSharedStorage(service: service)
    }
}
