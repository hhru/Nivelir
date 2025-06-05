#if canImport(UIKit) && canImport(Photos) && os(iOS)
import UIKit
import Photos

/// A result containing the original image and the edited image,
/// if an image was selected; or the file system URL for the movie, if a movie was selected.
/// The result also contains any relevant editing information.
public struct MediaPickerResult {

    /// The media type selected by the user.
    public let type: MediaPickerType?

    /// Metadata for a newly-captured photograph.
    public let metadata: [String: Any]?

    /// The filesystem URL for the movie.
    public let url: URL?

    /// The URL of the image file.
    public let imageURL: URL?

    /// The original, uncropped image selected by the user.
    public let originalImage: UIImage?

    /// An image edited by the user.
    public let editedImage: UIImage?

    /// The cropping rectangle that was applied to the original image.
    public let cropRect: CGRect?

    /// The Live Photo representation of the selected or captured photo.
    public let livePhoto: PHLivePhoto?

    /// A Photos asset for the image.
    public let phAsset: PHAsset?

    internal init(info: [String: Any]) {
        self.type = (info[UIImagePickerController.InfoKey.mediaType.rawValue] as? String)
            .flatMap(MediaPickerType.init(rawValue:))

        self.metadata = info[UIImagePickerController.InfoKey.mediaMetadata.rawValue] as? [String: Any]
        self.url = info[UIImagePickerController.InfoKey.mediaURL.rawValue] as? URL

        if #available(iOS 11.0, *) {
            self.imageURL = info[UIImagePickerController.InfoKey.imageURL.rawValue] as? URL
        } else {
            self.imageURL = nil
        }

        self.originalImage = info[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage
        self.editedImage = info[UIImagePickerController.InfoKey.editedImage.rawValue] as? UIImage

        if let value = info[UIImagePickerController.InfoKey.cropRect.rawValue] as? NSValue {
            self.cropRect = value.cgRectValue
        } else {
            self.cropRect = nil
        }

        self.livePhoto = info[UIImagePickerController.InfoKey.livePhoto.rawValue] as? PHLivePhoto

        if #available(iOS 11.0, *) {
            self.phAsset = info[UIImagePickerController.InfoKey.phAsset.rawValue] as? PHAsset
        } else {
            self.phAsset = nil
        }
    }
}
#endif
