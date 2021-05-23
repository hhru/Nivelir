#if canImport(MobileCoreServices)
import Foundation
import MobileCoreServices

public enum MediaPickerType {

    case image
    case movie

    public var rawValue: String {
        switch self {
        case .image:
            return kUTTypeImage as String

        case .movie:
            return kUTTypeMovie as String
        }
    }

    public init?(rawValue: String) {
        switch rawValue {
        case String(kUTTypeImage):
            self = .image

        case String(kUTTypeMovie):
            self = .movie

        default:
            return nil
        }
    }
}
#endif
