import Foundation

public struct ScreenContext<Wrapped> {

    private let wrapped: () -> [Wrapped]

    public init(wrapped: @escaping () -> [Wrapped]) {
        self.wrapped = wrapped
    }

    public func perform(_ body: (Wrapped) throws -> Void) rethrows {
        try wrapped().forEach(body)
    }
}
