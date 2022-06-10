#if canImport(UIKit) && os(iOS)
import UIKit

public struct MediaPicker: CustomStringConvertible {

    public let source: MediaPickerSource
    public let types: [MediaPickerType]
    public let allowsEditing: Bool
    public let imageExportPreset: MediaPickerImageExportPreset
    public let videoExportPreset: String?
    public let videoMaximumDuration: TimeInterval
    public let videoQuality: UIImagePickerController.QualityType

    public let didInitialize: ((_ container: UIImagePickerController) -> Void)?
    public let didFinish: (_ result: MediaPickerResult?) -> Void

    public var description: String {
        "ImagePicker(from: \"\(source)\")"
    }

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
