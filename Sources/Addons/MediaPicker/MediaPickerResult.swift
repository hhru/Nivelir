#if canImport(UIKit) && canImport(Photos) && os(iOS)
import UIKit
import Photos

public struct MediaPickerResult {

    public let type: MediaPickerType?
    public let metadata: [String: Any]?
    public let url: URL?
    public let imageURL: URL?
    public let referenceURL: URL?
    public let originalImage: UIImage?
    public let editedImage: UIImage?
    public let cropRect: CGRect?
    public let livePhoto: PHLivePhoto?
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
