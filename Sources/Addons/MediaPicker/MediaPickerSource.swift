#if canImport(UIKit) && os(iOS)
import UIKit

/// The source type to use when selecting an image or when determining the available media types.
///
/// A given source may not be available on a given device because the source is not physically present
/// or because it cannot currently be accessed.
@MainActor
public enum MediaPickerSource: CustomStringConvertible {

    /// Specifies the device’s photo library as the source for the image picker controller.
    case photoLibrary

    /// Specifies the device’s Camera Roll album as the source for the image picker controller.
    case savedPhotosAlbum

    /// Specifies the device’s built-in camera with settings as the source for the image picker controller.
    case camera(settings: MediaPickerCameraSettings)

    /// Specifies the device’s built-in camera with default settings as the source for the image picker controller.
    public static let camera = Self.camera(settings: .default)

    nonisolated public var description: String {
        switch self {
        case .photoLibrary:
            return "Photo library"

        case .savedPhotosAlbum:
            return "Saved photos album"

        case .camera:
            return "Camera"
        }
    }

    /// Queries whether the device supports picking media using the source type.
    ///
    /// `true` if the device supports the source type;
    /// `false` if the source type is not available.
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

    /// Retrieves the available media types for the source type.
    ///
    /// An array whose elements identify the available media types for the source type.
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
