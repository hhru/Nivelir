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

    private func performStack(
        _ newStack: [UIViewController],
        container: Container,
        completion: @escaping Completion
    ) {
        let stack = container.viewControllers

        guard newStack != stack else {
            return completion(.success)
        }

        let isAnimated = self.animation == nil
            ? false
            : !stack.isEmpty

        let isDefaultAnimated = isAnimated && (self.animation?.isDefault == true)

        if newStack == stack.dropLast() {
            container.popViewController(animated: isDefaultAnimated)
        } else if newStack.dropLast() == stack, let lastContainer = newStack.last {
            container.pushViewController(
                lastContainer,
                animated: isDefaultAnimated
            )
        } else {
            container.setViewControllers(
                newStack,
                animated: isDefaultAnimated
            )
        }

        guard isAnimated, let animation = self.animation else {
            return completion(.success)
        }

        animation.animate(container: container, stack: newStack) {
            completion(.success)
        }
    }

    public func combine<Action: ScreenAction>(
        with other: Action
    ) -> AnyScreenAction<Container, Void>? {
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
            animation: animation,
            separated: action.separated
        ).eraseToAnyVoidAction()
    }

    public func perform(
        container: Container,
        navigator: ScreenNavigator,
        completion: @escaping Completion
    ) {
        navigator.logInfo(
            """
            Setting stack of \(container) with modifiers:
            \(modifiers.map { "  - \($0)" }.joined(separator: "\n"))
            """
        )

        do {
            let newStack = try modifiers.reduce(container.viewControllers) { stack, modifier in
                try modifier.perform(
                    stack: stack,
                    navigator: navigator
                )
            }

            performStack(
                newStack,
                container: container,
                completion: completion
            )
        } catch {
            return completion(.failure(error))
        }
    }
}

extension ScreenThenable where Current: UINavigationController {

    public func setStack(
        modifiers: [ScreenStackModifier],
        animation: ScreenStackAnimation? = .default,
        separated: Bool = false
    ) -> Self {
        then(
            ScreenSetStackAction<Current>(
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
