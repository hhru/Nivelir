import Foundation

protocol ServiceScope {

    func storage(for service: Any) -> ServiceStorage
}
