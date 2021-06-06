import Foundation

/// A screen container on which the navigation is performed.
///
/// Any navigation is performed on containers, for UIKit they are divided into several types:
/// - Window container : instances of `UIWindow`
/// - Tabs container: instances of `UITabBarController`
/// - Stack container :  instances of `UINavigationController`
/// - Modal container :  instances of `UIViewController`
///
/// Since `UITabBarController` and `UINavigationController` are subclasses of `UIViewController`,
/// they are also modal containers.
///
/// This protocol is already implemented by the `UIWindow`, `UIViewController` classes and all their subclasses.
///
/// - SeeAlso: `Screen`
public protocol ScreenContainer { }
