import UIKit

public struct ScreenCustomWindowProvider: ScreenWindowProvider {

    public private(set) weak var window: UIWindow?

    public init(window: UIWindow) {
        self.window = window
    }
}
