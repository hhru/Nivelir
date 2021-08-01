#if canImport(UIKit)
import UIKit

public protocol ScreenStackModifier: CustomStringConvertible {
    func perform(
        in stack: [UIViewController],
        navigator: ScreenNavigator
    ) throws -> [UIViewController]
}
#endif
