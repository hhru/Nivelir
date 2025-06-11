#if canImport(UIKit) && os(iOS)
import UIKit

internal final class MediaPickerProxy: NSObject, Sendable {

    private let mediaPicker: MediaPicker

    internal init(mediaPicker: MediaPicker) {
        self.mediaPicker = mediaPicker
    }

    @MainActor
    @objc internal func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo rawInfo: [String: Any]
    ) {
        var info: [UIImagePickerController.InfoKey: Any] = [:]

        for (key, value) in rawInfo {
            info[UIImagePickerController.InfoKey(rawValue: key)] = value
        }

        mediaPicker.didFinish(MediaPickerResult(info: info))
    }

    @MainActor
    @objc internal func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        mediaPicker.didFinish(nil)
    }
}
#endif
