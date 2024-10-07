import Foundation

@MainActor
public protocol ScreenRefreshableContainer: ScreenContainer {

    func refresh(completion: @escaping () -> Void)
}
