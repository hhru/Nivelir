#if canImport(UIKit)
import Foundation

public struct BottomSheetDetent: Sendable {

    public typealias Resolver = @MainActor @Sendable (_ context: BottomSheetDetentContext) -> CGFloat?

    public let key: BottomSheetDetentKey
    public let resolver: Resolver

    private init(
        key: BottomSheetDetentKey,
        resolver: @escaping Resolver
    ) {
        self.key = key
        self.resolver = resolver
    }

    @MainActor
    internal func resolve(for context: BottomSheetDetentContext) -> CGFloat? {
        resolver(context)
    }
}

extension BottomSheetDetent {

    public static var content: Self {
        Self(key: .content) { context in
            context
                .presentedViewController
                .preferredContentSize
                .height
        }
    }

    public static var medium: Self {
        Self(key: .medium) { context in
            switch context.containerTraitCollection.verticalSizeClass {
            case .regular:
                return context.maximumDetentValue * 0.5

            case .compact, .unspecified:
                return nil

            @unknown default:
                return nil
            }
        }
    }

    public static var large: Self {
        Self(key: .large) { context in
            context.maximumDetentValue
        }
    }

    public static func custom(
        key: BottomSheetDetentKey,
        resolver: @escaping Resolver
    ) -> Self {
        Self(
            key: key,
            resolver: resolver
        )
    }
}
#endif
