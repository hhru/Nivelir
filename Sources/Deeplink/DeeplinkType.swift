import Foundation

/// Different types of deep links.
public enum DeeplinkType {

    /// A ``Deeplink`` handled from a URL.
    case url

    /// A ``Deeplink`` handled from a Notification.
    case notification

    /// A ``Deeplink`` handled from a Shortcut.
    case shortcut
}
