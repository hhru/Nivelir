import Foundation

public final class ScreenActionStorage<State> {

    public private(set) var state: State?

    internal init() { }

    public func storeState(_ state: State) {
        self.state = state
    }

    public func clear() {
        state = nil
    }
}
