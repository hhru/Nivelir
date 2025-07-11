#if canImport(UIKit) && os(iOS)
import UIKit

/// A type that specifies how to export images to the client application.
@frozen
public enum MediaPickerImageExportPreset: Sendable {

    @available(iOS 11, *)
    /// A preset for passing image data as-is to the client.
    case current

    /// A preset for converting HEIF formatted images to JPEG.
    case compatible
}
#endif
