import Foundation

/// Protocol-Mark for Observers.
///
/// The protocol is inherited in other protocols that the observers will implement.
///
/// ```swift
/// protocol EmployerReviewObserver: ScreenObserver {
///     func employerFeedbackRead(employerReviewID: Int)
/// }
/// ```
public protocol ScreenObserver: AnyObject { }
