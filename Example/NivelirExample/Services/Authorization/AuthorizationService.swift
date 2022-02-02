import Foundation

protocol AuthorizationService {

    var isAuthorized: Bool { get }

    func login(phoneNumber: String)
    func logout()
}
