import UIKit

final class DefaultProfileService: ProfileService {

    private let authorizationService: AuthorizationService

    init(authorizationService: AuthorizationService) {
        self.authorizationService = authorizationService
    }

    private func finishSucceedUploading(
        timer: Timer,
        progress: @escaping (_ ratio: CGFloat) -> Void,
        completion: @escaping (_ result: Result<Void, Error>) -> Void
    ) {
        timer.invalidate()
        progress(1.0)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            completion(.success(Void()))
        }
    }

    private func finishFailedUploading(
        timer: Timer,
        completion: @escaping (_ result: Result<Void, Error>) -> Void
    ) {
        timer.invalidate()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            completion(.failure(ProfileError.unavailable))
        }
    }

    func uploadPhoto(
        image: UIImage,
        progress: @escaping (_ ratio: CGFloat) -> Void,
        completion: @escaping (_ result: Result<Void, Error>) -> Void
    ) {
        guard authorizationService.isAuthorized else {
            return completion(.failure(ProfileError.unauthorized))
        }

        var intervalCount: CGFloat = .zero

        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
            guard intervalCount <= 100 else {
                return self.finishSucceedUploading(
                    timer: timer,
                    progress: progress,
                    completion: completion
                )
            }

            let random = Int.random(in: 1...1000)

            guard random < 997 || intervalCount < 50 else {
                return self.finishFailedUploading(
                    timer: timer,
                    completion: completion
                )
            }

            progress(intervalCount * 0.01)

            intervalCount += 1.0
        }
    }
}
