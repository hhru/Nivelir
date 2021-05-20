import Foundation

public protocol ScreenLogger {
    func info(_ info: @autoclosure () -> String)
    func error(_ error: @autoclosure () -> Error)
}
