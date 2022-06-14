#if canImport(UIKit) && os(iOS)
import UIKit

internal final class MediaPickerManager: NSObject, UINavigationControllerDelegate {

    private let mediaPicker: MediaPicker

    internal init(mediaPicker: MediaPicker) {
        self.mediaPicker = mediaPicker
    }
}

extension MediaPickerManager: UIImagePickerControllerDelegate {

    internal func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        mediaPicker.didFinish(MediaPickerResult(info: info))
    }

    internal func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        mediaPicker.didFinish(nil)
    }
}
#endif
