import Foundation

extension String {

    internal static let urlPercentEscapedSpace = "%20"
    internal static let urlPlusReplacedSpace = "+"
    internal static let urlPathSeparator = "/"

    internal static let newLine = "\n"

    internal func indented(spaces: Int) -> String {
        let spaces = String(repeating: " ", count: spaces)

        return components(separatedBy: .newlines)
            .joined(separator: "\n\(spaces)")
            .prepending(contentsOf: spaces)
    }
}
