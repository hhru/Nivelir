#if canImport(UIKit)
import UIKit

public protocol ScreenStackModifier: CustomStringConvertible {

    @MainActor
    func perform(
        stack: [UIViewController],
        navigator: ScreenNavigator
    ) throws -> [UIViewController]
}
#endif
