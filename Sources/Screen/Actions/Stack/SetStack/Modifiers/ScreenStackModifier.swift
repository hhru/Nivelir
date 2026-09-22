#if canImport(UIKit)
import UIKit

@MainActor
public protocol ScreenStackModifier: CustomStringConvertible {

    func perform(
        stack: [UIViewController],
        navigator: ScreenNavigator
    ) throws -> [UIViewController]
}
#endif
