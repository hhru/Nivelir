import UIKit

protocol ProfileService {

    @MainActor
    func uploadPhoto(
        image: UIImage,
        progress: @MainActor @Sendable @escaping (_ ratio: CGFloat) -> Void,
        completion: @MainActor @Sendable @escaping (_ result: Result<Void, Error>) -> Void
    )
}
