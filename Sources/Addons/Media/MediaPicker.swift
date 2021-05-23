#if canImport(UIKit) && os(iOS)
import UIKit

public struct MediaPicker {

    public typealias Handler = (_ result: MediaPickerResult?) -> Void

    public let source: MediaPickerSource
    public let types: [MediaPickerType]
    public let allowsEditing: Bool
    public let imageExportPreset: MediaPickerImageExportPreset
    public let videoExportPreset: String?
    public let videoMaximumDuration: TimeInterval
    public let videoQuality: UIImagePickerController.QualityType
    public let handler: Handler

    @available(iOS 11, *)
    public init(
        source: MediaPickerSource = .photoLibrary,
        types: [MediaPickerType] = [.image],
        allowsEditing: Bool = false,
        imageExportPreset: MediaPickerImageExportPreset = .compatible,
        videoExportPreset: String? = nil,
        videoMaximumDuration: TimeInterval = 600.0,
        videoQuality: UIImagePickerController.QualityType = .typeMedium,
        handler: @escaping Handler
    ) {
        self.source = source
        self.types = types
        self.allowsEditing = allowsEditing
        self.imageExportPreset = imageExportPreset
        self.videoExportPreset = videoExportPreset
        self.videoMaximumDuration = videoMaximumDuration
        self.videoQuality = videoQuality
        self.handler = handler
    }

    public init(
        source: MediaPickerSource = .photoLibrary,
        types: [MediaPickerType] = [.image],
        allowsEditing: Bool = false,
        videoMaximumDuration: TimeInterval = 600.0,
        videoQuality: UIImagePickerController.QualityType = .typeMedium,
        handler: @escaping Handler
    ) {
        self.source = source
        self.types = types
        self.allowsEditing = allowsEditing
        self.imageExportPreset = .compatible
        self.videoExportPreset = nil
        self.videoMaximumDuration = videoMaximumDuration
        self.videoQuality = videoQuality
        self.handler = handler
    }
}
#endif
