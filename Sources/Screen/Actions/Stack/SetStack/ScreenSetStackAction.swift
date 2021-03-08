#if canImport(UIKit)
import UIKit

public struct ScreenSetStackAction<Container: UINavigationController>: ScreenAction {

    public typealias Output = Void

    public let modifiers: [ScreenStackModifier]
    public let animation: ScreenStackAnimation?
    public let separated: Bool

    public init(
        modifiers: [ScreenStackModifier],
        animation: ScreenStackAnimation? = .default,
        separated: Bool = false
    ) {
        self.modifiers = modifiers
        self.animation = animation
        self.separated = separated
    }

    public init(
        modifier: ScreenStackModifier,
        animation: ScreenStackAnimation? = .default,
        separated: Bool = false
    ) {
        self.init(
            modifiers: [modifier],
            animation: animation,
            separated: separated
        )
    }

    private func resolveAnimation(
        first: ScreenStackAnimation?,
        second: ScreenStackAnimation?
    ) -> ScreenStackAnimation? {
        switch (first, second) {
        case (nil, nil):
            return nil

        case let (first?, nil):
            return first

        case let (nil, second?):
            return second

        case let (first?, second?) where first == second:
            return second

        case (_?, _?):
            return .default
        }
    }

    public func combine(with other: AnyScreenAction) -> [AnyScreenAction] {
        guard !separated, let action = other as? Self else {
            return [self, other]
        }

        let modifiers = self
            .modifiers
            .appending(contentsOf: action.modifiers)

        let animation = resolveAnimation(
            first: self.animation,
            second: action.animation
        )

        return [Self(modifiers: modifiers, animation: animation)]
    }

    public func perform(
        container: Container,
        navigation: ScreenNavigation,
        completion: @escaping Completion
    ) {
        navigation.logger?.info(
            """
            Setting stack of \(container) with modifiers:
            \(modifiers.map { "  - \($0)" }.joined(separator: "\n"))
            """
        )

        let stack: [UIViewController]

        do {
            stack = try modifiers.reduce(container.viewControllers) { stack, modifier in
                try modifier.perform(
                    in: stack,
                    navigation: navigation
                )
            }
        } catch {
            return completion(.failure(error))
        }

        let isAnimated = animation == nil
            ? false
            : !container.viewControllers.isEmpty

        container.setViewControllers(
            stack,
            animated: isAnimated && (animation?.isDefault == true)
        )

        guard isAnimated, let animation = animation else {
            return completion(.success)
        }

        animation.animate(
            container: container,
            stack: stack
        ) {
            completion(.success)
        }
    }
}

extension ScreenRoute where Container: UINavigationController {

    public func setStack(
        modifiers: [ScreenStackModifier],
        animation: ScreenStackAnimation? = .default,
        separated: Bool = false
    ) -> Self {
        then(
            action: ScreenSetStackAction<Container>(
                modifiers: modifiers,
                animation: animation,
                separated: separated
            )
        )
    }

    public func setStack(
        modifier: ScreenStackModifier,
        animation: ScreenStackAnimation? = .default,
        separated: Bool = false
    ) -> Self {
        setStack(
            modifiers: [modifier],
            animation: animation,
            separated: separated
        )
    }
}
#endif
