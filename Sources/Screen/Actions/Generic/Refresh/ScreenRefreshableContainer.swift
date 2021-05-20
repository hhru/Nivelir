import Foundation

public protocol ScreenRefreshableContainer: ScreenContainer {
    func refresh(completion: @escaping () -> Void)
}
