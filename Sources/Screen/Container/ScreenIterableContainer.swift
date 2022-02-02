#if canImport(UIKit)
import UIKit

public protocol ScreenIterableContainer: ScreenContainer {

    var nestedContainers: [ScreenContainer] { get }
}
#endif
