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

    private func performModifiers(
        from index: Int = .zero,
        in stack: [UIViewController],
        navigation: ScreenNavigation,
        completion: @escaping ScreenStackModifier.Completion
    ) {
        guard index < modifiers.count else {
            return completion(.success(stack))
        }

        modifiers[index].perform(in: stack, navigation: navigation) { result in
            switch result {
            case let .success(stack):
                performModifiers(
                    from: index + 1,
                    in: stack,
                    navigation: navigation,
                    completion: completion
                )

            case let .failure(error):
                completion(.failure(error))
            }
        }
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

    public func combine<Action: ScreenAction>(
        with other: Action
    ) -> Action? where Action.Container == Container {
        guard !separated, let action = other.cast(to: Self.self) else {
            return nil
        }

        let modifiers = self
            .modifiers
            .appending(contentsOf: action.modifiers)

        let animation = resolveAnimation(
            first: self.animation,
            second: action.animation
        )

        return Self(
            modifiers: modifiers,
            animation: animation
        ) as? Action
    }

    public func perform(
        container: Container,
        navigation: ScreenNavigation,
        completion: @escaping Completion
    ) {
        navigation.logInfo(
            """
            Setting stack of \(container) with modifiers:
            \(modifiers.map { "  - \($0)" }.joined(separator: "\n"))
            """
        )

        performModifiers(in: container.viewControllers, navigation: navigation) { result in
            switch result {
            case let .success(stack):
                let isAnimated = self.animation == nil
                    ? false
                    : !container.viewControllers.isEmpty

                let isDefaultAnimated = isAnimated && (self.animation?.isDefault == true)

                container.setViewControllers(
                    stack,
                    animated: isDefaultAnimated
                )

                guard isAnimated, let animation = self.animation else {
                    return completion(.success)
                }

                animation.animate(container: container, stack: stack) {
                    completion(.success)
                }

            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}

extension ScreenThenable where Then: UINavigationController {

    public func setStack(
        modifiers: [ScreenStackModifier],
        animation: ScreenStackAnimation? = .default,
        separated: Bool = false
    ) -> Self {
        then(
            ScreenSetStackAction<Then>(
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
