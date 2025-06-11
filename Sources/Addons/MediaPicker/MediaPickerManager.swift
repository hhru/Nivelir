#if canImport(UIKit) && os(iOS)
import UIKit

internal final class MediaPickerManager:
    NSObject,
    UINavigationControllerDelegate,
    UIImagePickerControllerDelegate {

    nonisolated private let proxy: MediaPickerProxy

    internal init(mediaPicker: MediaPicker) {
        self.proxy = MediaPickerProxy(mediaPicker: mediaPicker)
    }

    internal override func responds(to aSelector: Selector?) -> Bool {
        super.responds(to: aSelector) || proxy.responds(to: aSelector) == true
    }

    internal override func forwardingTarget(for aSelector: Selector?) -> Any? {
        if proxy.responds(to: aSelector) == true {
            return proxy
        }

        return super.forwardingTarget(for: aSelector)
    }
}
#endif
