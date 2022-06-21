#if canImport(UIKit)
import Foundation

public struct Progress: CustomStringConvertible {

    public let header: AnyProgressContent
    public let indicator: AnyProgressContent
    public let footer: AnyProgressContent
    public let animation: ProgressAnimation?

    public var description: String {
        let fields = [
            "header": header,
            "indicator": indicator,
            "footer": footer
        ]

        return fields
            .compactMap { key, value in
                value.logDescription.map { (key, $0) }
            }
            .map { "\($0): \($1)" }
            .joined(separator: ", ")
    }

    public init<
        Header: ProgressHeader,
        Indicator: ProgressIndicator,
        Footer: ProgressFooter
    >(
        header: Header,
        indicator: Indicator,
        footer: Footer,
        animation: ProgressAnimation? = .default
    ) {
        self.header = header
        self.indicator = indicator
        self.footer = footer
        self.animation = animation
    }
}

extension Progress {

    public static func indicator<Indicator: ProgressIndicator>(
        _ indicator: Indicator,
        animation: ProgressAnimation? = .default
    ) -> Self {
        Self(
            header: ProgressEmptyHeader.default,
            indicator: indicator,
            footer: ProgressEmptyFooter.default,
            animation: animation
        )
    }

    public static func indicator<Indicator: ProgressIndicator>(
        _ indicator: Indicator,
        message: ProgressMessageFooter,
        animation: ProgressAnimation? = .default
    ) -> Self {
        Self(
            header: ProgressEmptyHeader.default,
            indicator: indicator,
            footer: message,
            animation: animation
        )
    }
}
#endif
