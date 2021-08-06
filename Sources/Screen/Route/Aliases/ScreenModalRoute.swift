#if canImport(UIKit)
import UIKit

/// Alias for the root route whose container type is `UIViewController`.
///
/// - SeeAlso: `ScreenRoute`
/// - SeeAlso: `ScreenRootRoute`
public typealias ScreenModalRoute = ScreenRootRoute<UIViewController>
#endif
