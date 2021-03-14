import Foundation

public final class DefaultScreenLogger: ScreenLogger {

    public let isInfoEnabled: Bool
    public let isErrorsEnabled: Bool

    public init(
        isInfoEnabled: Bool = true,
        isErrorsEnabled: Bool = true
    ) {
        self.isInfoEnabled = isInfoEnabled
        self.isErrorsEnabled = isErrorsEnabled
    }

    public func info(_ info: @autoclosure () -> String) {
        if isInfoEnabled {
            print("Nivelir info: \(info())")
        }
    }

    public func error(_ error: @autoclosure () -> Error) {
        if isErrorsEnabled {
            print("Nivelir error: \(error())")
        }
    }
}
