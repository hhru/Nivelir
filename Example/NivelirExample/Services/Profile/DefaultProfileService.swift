import UIKit

final class DefaultProfileService: ProfileService, Sendable {

    private class UncheckedCGFloat: @unchecked Sendable {
        var value: CGFloat = .zero
    }

    private let authorizationService: AuthorizationService
    private let intervalCount = UncheckedCGFloat()

    init(authorizationService: AuthorizationService) {
        self.authorizationService = authorizationService
    }

    func uploadPhoto(
        image: UIImage,
        progress: @MainActor @Sendable @escaping (_ ratio: CGFloat) -> Void,
        completion: @MainActor @Sendable @escaping (_ result: Result<Void, Error>) -> Void
    ) {
        intervalCount.value = .zero
        guard authorizationService.isAuthorized else {
            return completion(.failure(ProfileError.unauthorized))
        }

        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] timer in
            guard let self else {
                return
            }

            guard intervalCount.value <= 100 else {
                timer.invalidate()

                Task { @MainActor in
                    progress(1.0)
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    completion(.success(Void()))
                }
                return
            }

            let random = Int.random(in: 1...1000)

            guard random < 997 || intervalCount.value < 50 else {
                timer.invalidate()

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    completion(.failure(ProfileError.unavailable))
                }
                return
            }

            Task { @MainActor in
                progress(self.intervalCount.value * 0.01)
            }

            intervalCount.value += 1.0
        }
    }
}
