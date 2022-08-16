#if canImport(UIKit) && os(iOS)
import UIKit

/// An object for configuring a selection of media items (photos and videos) from the Library or Camera.
public struct MediaPicker: CustomStringConvertible {

    /// The type of picker interface to be displayed by the controller.
    public let source: MediaPickerSource

    /// An array that indicates the media types to be accessed by the media picker controller.
    public let types: [MediaPickerType]

    /// A Boolean value that indicates whether the user is allowed to edit a selected still image or movie.
    public let allowsEditing: Bool

    /// The preset to use when preparing images for export to your app.
    public let imageExportPreset: MediaPickerImageExportPreset

    /// The preset to use when preparing video for export to your app.
    public let videoExportPreset: String?

    /// The maximum duration, in seconds, for a video recording.
    public let videoMaximumDuration: TimeInterval

    /// The video recording and transcoding quality.
    public let videoQuality: UIImagePickerController.QualityType

    /// Closure to configure the `UIImagePickerController` after initialization.
    public let didInitialize: ((_ container: UIImagePickerController) -> Void)?

    /// Closure with result,
    /// called when the user has selected a still image or movie or has canceled the pick operation.
    public let didFinish: (_ result: MediaPickerResult?) -> Void

    public var description: String {
        "ImagePicker(from: \"\(source)\")"
    }

    /// Creates a configuration for selecting media items.
    /// - Parameters:
    ///   - source: The type of picker interface to be displayed by the controller.
    ///   - types: An array that indicates the media types to be accessed by the media picker controller.
    ///   - allowsEditing: A Boolean value that indicates whether
    ///   the user is allowed to edit a selected still image or movie.
    ///   - imageExportPreset: The preset to use when preparing images for export to your app.
    ///   - videoExportPreset: The preset to use when preparing video for export to your app.
    ///   - videoMaximumDuration: The maximum duration, in seconds, for a video recording.
    ///   - videoQuality: The video recording and transcoding quality.
    ///   - didInitialize: Closure to configure the `UIImagePickerController` after initialization.
    ///   - didFinish: Closure with result, called when the user
    ///   has selected a still image or movie or has canceled the pick operation.
    @available(iOS 11, *)
    public init(
        source: MediaPickerSource = .photoLibrary,
        types: [MediaPickerType] = [.image],
        allowsEditing: Bool = false,
        imageExportPreset: MediaPickerImageExportPreset = .compatible,
        videoExportPreset: String? = nil,
        videoMaximumDuration: TimeInterval = 600.0,
        videoQuality: UIImagePickerController.QualityType = .typeMedium,
        didInitialize: ((_ container: UIImagePickerController) -> Void)? = nil,
        didFinish: @escaping (_ result: MediaPickerResult?) -> Void
    ) {
        self.source = source
        self.types = types
        self.allowsEditing = allowsEditing
        self.imageExportPreset = imageExportPreset
        self.videoExportPreset = videoExportPreset
        self.videoMaximumDuration = videoMaximumDuration
        self.videoQuality = videoQuality

        self.didInitialize = didInitialize
        self.didFinish = didFinish
    }

    /// Creates a configuration for selecting media items.
    /// - Parameters:
    ///   - source: The type of picker interface to be displayed by the controller.
    ///   - types: An array that indicates the media types to be accessed by the media picker controller.
    ///   - allowsEditing: A Boolean value that indicates whether
    ///   the user is allowed to edit a selected still image or movie.
    ///   - videoMaximumDuration: The maximum duration, in seconds, for a video recording.
    ///   - videoQuality: The video recording and transcoding quality.
    ///   - didInitialize: Closure to configure the `UIImagePickerController` after initialization.
    ///   - didFinish: Closure with result, called when the user
    ///   has selected a still image or movie or has canceled the pick operation.
    public init(
        source: MediaPickerSource = .photoLibrary,
        types: [MediaPickerType] = [.image],
        allowsEditing: Bool = false,
        videoMaximumDuration: TimeInterval = 600.0,
        videoQuality: UIImagePickerController.QualityType = .typeMedium,
        didInitialize: ((_ container: UIImagePickerController) -> Void)? = nil,
        didFinish: @escaping (_ result: MediaPickerResult?) -> Void
    ) {
        self.source = source
        self.types = types
        self.allowsEditing = allowsEditing
        self.imageExportPreset = .compatible
        self.videoExportPreset = nil
        self.videoMaximumDuration = videoMaximumDuration
        self.videoQuality = videoQuality

        self.didInitialize = didInitialize
        self.didFinish = didFinish
    }
}
#endif
