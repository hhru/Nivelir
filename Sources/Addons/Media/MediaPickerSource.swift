#if canImport(UIKit) && os(iOS)
import UIKit

public enum MediaPickerSource {

    case photoLibrary
    case savedPhotosAlbum
    case camera(settings: MediaPickerCameraSettings)

    public var isAvailable: Bool {
        switch self {
        case .photoLibrary:
            return UIImagePickerController.isSourceTypeAvailable(.photoLibrary)

        case .savedPhotosAlbum:
            return UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum)

        case .camera:
            return UIImagePickerController.isSourceTypeAvailable(.camera)
        }
    }

    public var availableMediaTypes: [MediaPickerType] {
        let rawAvailableMediaTypes: [String]?

        switch self {
        case .photoLibrary:
            rawAvailableMediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)

        case .savedPhotosAlbum:
            rawAvailableMediaTypes = UIImagePickerController.availableMediaTypes(for: .savedPhotosAlbum)

        case .camera:
            rawAvailableMediaTypes = UIImagePickerController.availableMediaTypes(for: .camera)
        }

        return rawAvailableMediaTypes?.compactMap(MediaPickerType.init(rawValue:)) ?? []
    }
}
#endif
