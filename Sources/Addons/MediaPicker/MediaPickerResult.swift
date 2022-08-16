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

    /// The Assets Library URL for the original version of the picked item.
    public let referenceURL: URL?

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

    internal init(info: [UIImagePickerController.InfoKey: Any]) {
        self.type = info[.mediaType]
            .flatMap { $0 as? String }
            .flatMap(MediaPickerType.init(rawValue:))

        self.metadata = info[.mediaMetadata] as? [String: Any]

        self.url = info[.mediaURL] as? URL

        if #available(iOS 11.0, *) {
            self.imageURL = info[.imageURL] as? URL
        } else {
            self.imageURL = nil
        }

        self.referenceURL = info[.referenceURL] as? URL
        self.originalImage = info[.originalImage] as? UIImage
        self.editedImage = info[.editedImage] as? UIImage

        self.cropRect = info[.cropRect]
            .flatMap { $0 as? NSValue }
            .map { $0.cgRectValue }

        self.livePhoto = info[.livePhoto] as? PHLivePhoto

        if #available(iOS 11.0, *) {
            self.phAsset = info[.phAsset] as? PHAsset
        } else {
            self.phAsset = nil
        }
    }
}
#endif
