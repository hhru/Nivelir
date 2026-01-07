#if canImport(MobileCoreServices) && os(iOS)
import Foundation
import MobileCoreServices

/// The media type to be accessed by the media picker controller.
///
/// Depending on the media types,
/// the picker displays a dedicated interface for still images or movies,
/// or a selection control that lets the user choose the picker interface.
///
/// When capturing media, the value of this enum determines the camera interface to display.
/// When browsing saved media, this enum determines the types of media presented in the interface.
///
/// ``image`` designates the still camera interface when capturing media,
/// and specifies that only still images should be displayed in the media picker when browsing saved media.
/// To designate the movie capture interface,
/// or to indicate that only movies should be displayed when browsing saved media, use the ``movie``.
///
/// - Note: If you want to display a Live Photo rendered as a Loop or a Bounce, you must include ``movie`` case.
///
/// To designate all available media types for a source, use a ``MediaPickerSource/availableMediaTypes``.
@frozen
public enum MediaPickerType: Sendable {

    /// The designates the still camera interface when capturing media,
    /// and specifies that only still images should be displayed in the media picker when browsing saved media.
    case image

    /// The designates the movie capture interface,
    /// or to indicate that only movies should be displayed when browsing saved media.
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
