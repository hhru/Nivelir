import Foundation

public struct ScreenIterationPredicate {

    private let box: (_ container: ScreenContainer) -> ScreenIterationResult

    public init(_ box: @escaping (_ container: ScreenContainer) -> ScreenIterationResult) {
        self.box = box
    }

    public func checkContainer(_ container: ScreenContainer) -> ScreenIterationResult {
        box(container)
    }
}
