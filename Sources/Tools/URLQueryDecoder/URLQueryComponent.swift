import Foundation

internal indirect enum URLQueryComponent {

    case string(String)
    case array([Int: Self])
    case dictionary([String: Self])

    internal var string: String? {
        switch self {
        case let .string(string):
            return string

        default:
            return nil
        }
    }

    internal var array: [Int: Self]? {
        switch self {
        case let .array(array):
            return array

        default:
            return nil
        }
    }

    internal var dictionary: [String: Self]? {
        switch self {
        case let .dictionary(dictionary):
            return dictionary

        default:
            return nil
        }
    }
}
