#if canImport(UIKit) && os(iOS)
import UIKit

/// The object that defines the settings for the camera.
public struct MediaPickerCameraSettings: Sendable {

    /// Default settings
    public static let `default` = Self()

    /// The camera used by the image picker controller.
    public let device: UIImagePickerController.CameraDevice

    /// The capture mode used by the camera.
    public let captureMode: UIImagePickerController.CameraCaptureMode

    /// The flash mode used by the active camera.
    public let flashMode: UIImagePickerController.CameraFlashMode

    /// - Parameters:
    ///   - device: The camera used by the image picker controller.
    ///   - captureMode: The capture mode used by the camera.
    ///   - flashMode: The flash mode used by the active camera.
    public init(
        device: UIImagePickerController.CameraDevice = .rear,
        captureMode: UIImagePickerController.CameraCaptureMode = .photo,
        flashMode: UIImagePickerController.CameraFlashMode = .auto
    ) {
        self.device = device
        self.captureMode = captureMode
        self.flashMode = flashMode
    }
}
#endif
