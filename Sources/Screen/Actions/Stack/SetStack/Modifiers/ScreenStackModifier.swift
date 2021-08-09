#if canImport(UIKit)
import UIKit

public protocol ScreenStackModifier: CustomStringConvertible {
    func perform(
        stack: [UIViewController],
        navigator: ScreenNavigator
    ) throws -> [UIViewController]
}
#endif
