#if canImport(UIKit) && os(iOS)
import UIKit

internal final class MediaPickerManager: NSObject, UINavigationControllerDelegate {

    private let mediaPicker: MediaPicker

    internal init(mediaPicker: MediaPicker) {
        self.mediaPicker = mediaPicker
    }
}

extension MediaPickerManager: UIImagePickerControllerDelegate {

    @objc internal func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String: Any]
    ) {
        mediaPicker.didFinish(MediaPickerResult(info: info))
    }

    internal func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        mediaPicker.didFinish(nil)
    }
}
#endif
