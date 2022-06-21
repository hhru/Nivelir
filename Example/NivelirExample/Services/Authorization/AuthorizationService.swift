import Foundation

protocol AuthorizationService {

    var isAuthorized: Bool { get }

    func login(
        phoneNumber: String,
        completion: @escaping (_ result: Result<Void, Error>) -> Void
    )

    func logout()
}
