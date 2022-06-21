import Foundation

final class DefaultAuthorizationService: AuthorizationService {

    var isAuthorized: Bool {
        get { UserDefaults.standard.bool(forKey: #function) }
        set { UserDefaults.standard.set(newValue, forKey: #function) }
    }

    func login(
        phoneNumber: String,
        completion: @escaping (_ result: Result<Void, Error>) -> Void
    ) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let random = Int.random(in: 1...10)

            guard random < 8 else {
                return completion(.failure(AuthorizationError.unavailable))
            }

            self.isAuthorized = true

            completion(.success(Void()))
        }
    }

    func logout() {
        self.isAuthorized = false
    }
}
