import Foundation

protocol AuthorizationService: Sendable {

    var isAuthorized: Bool { get }

    @MainActor
    func login(
        phoneNumber: String,
        completion: @escaping (_ result: Result<Void, Error>) -> Void
    )

    func logout()
}
