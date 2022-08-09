import Foundation

/// Different types of deep links.
public enum DeeplinkType {

    /// A deep link handled from a URL.
    case url

    /// A deep link handled from a Notification.
    case notification

    /// A deep link handled from a Shortcut.
    case shortcut
}
