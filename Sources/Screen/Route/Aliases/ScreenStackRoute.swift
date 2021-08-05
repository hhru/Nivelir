#if canImport(UIKit)
import UIKit

/// Alias for the root route whose container type is `UINavigationController`.
///
/// - SeeAlso: `ScreenRoute`
/// - SeeAlso: `ScreenRootRoute`
public typealias ScreenStackRoute = ScreenRootRoute<UINavigationController>
#endif
