import Foundation

public final class DefaultScreenLogger: ScreenLogger {

    public init() { }

    public func info(_ info: @autoclosure () -> String) {
        print("Nivelir info: \(info())")
    }

    public func error(_ error: @autoclosure () -> Error) {
        print("Nivelir error: \(error())")
    }
}
