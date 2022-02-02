import Foundation

final class DefaultAuthorizationService: AuthorizationService {

    var isAuthorized: Bool {
        get { UserDefaults.standard.bool(forKey: #function) }
        set { UserDefaults.standard.set(newValue, forKey: #function) }
    }

    func login(phoneNumber: String) {
        isAuthorized = true
    }

    func logout() {
        isAuthorized = false
    }
}
