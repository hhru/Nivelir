#if canImport(UIKit)
import UIKit

public protocol ScreenStackModifier: CustomStringConvertible {
    func perform(
        in stack: [UIViewController],
        navigation: ScreenNavigation
    ) throws -> [UIViewController]
}
#endif
