import UIKit

protocol ProfileService {

    func uploadPhoto(
        image: UIImage,
        progress: @escaping (_ ratio: CGFloat) -> Void,
        completion: @escaping (_ result: Result<Void, Error>) -> Void
    )
}
