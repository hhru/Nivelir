import Foundation

/// Screen navigation logger.
public protocol ScreenLogger {

    /// Logs a message.
    ///
    /// - Parameter info: Info message to be logged.
    func info(_ info: @autoclosure () -> String)

    /// Logs an error.
    ///
    /// - Parameter error: Error to be logged.
    func error(_ error: @autoclosure () -> Error)
}
