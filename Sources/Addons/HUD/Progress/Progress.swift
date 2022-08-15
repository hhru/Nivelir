#if canImport(UIKit)
import Foundation

/// The object containing the data to be displayed in ``ProgressView``.
///
/// Progress is fully customizable and is built from three components - header, indicator and footer.
/// For each of these components, you can use your own views,
/// which are configured through the content
/// by implementing the appropriate protocols ``ProgressHeader``, ``ProgressIndicator`` and ``ProgressFooter``.
/// Each component is displayed with an animation defined in the ``animation`` property.
public struct Progress: CustomStringConvertible {

    /// Erased type of header content.
    public let header: AnyProgressContent

    /// Erased type of indicator content.
    public let indicator: AnyProgressContent

    /// Erased type of footer content.
    public let footer: AnyProgressContent

    /// Animation of the appearance of progress components.
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

    /// Creates a new object with progress components and animation.
    /// - Parameters:
    ///   - header: Header representation.
    ///   - indicator: Indicator representation.
    ///   - footer: Footer representation.
    ///   - animation: Animation of the display components of progress.
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

    /// Creates a new object with an indicator only.
    /// The header and footer are empty views.
    /// - Parameters:
    ///   - indicator: Indicator representation.
    ///   - animation: Animation of the display components of progress. Can be `nil` to show without animation.
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

    /// Creates a new object with an indicator and a footer with a message.
    /// The header is an empty view.
    /// - Parameters:
    ///   - indicator: Indicator representation.
    ///   - message: The properties of a ``ProgressMessageFooterView`` instance.
    ///   - animation: Animation of the display components of progress. Can be `nil` to show without animation.
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
