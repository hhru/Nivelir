import UIKit

public struct MediaPickerCameraSettings {

    public let device: UIImagePickerController.CameraDevice
    public let captureMode: UIImagePickerController.CameraCaptureMode
    public let flashMode: UIImagePickerController.CameraFlashMode

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
