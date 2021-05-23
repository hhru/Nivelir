#if canImport(UIKit) && os(iOS)
import UIKit

public enum MediaPickerImageExportPreset {

    @available(iOS 11, *)
    case current

    case compatible
}
#endif
