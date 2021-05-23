import Foundation

public final class ScreenPayload {

    private var bag: [Any] = []

    public func store(_ item: Any) {
        bag.append(item)
    }

    public func clear() {
        bag.removeAll()
    }
}
