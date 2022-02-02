import Foundation

struct ServiceSharedStorage: ServiceStorage {

    let service: Any?

    init(service: Any) {
        self.service = service
    }
}
