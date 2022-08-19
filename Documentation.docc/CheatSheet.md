# Cheat Sheet

Learn the most common use cases for Nivelir.

## Screen Search

Use the ``ScreenThenable/first(_:)`` and ``ScreenThenable/last(_:)`` methods with the given predicate to find the desired screen. This example will try to find a chat screen that displays chat with `id = 2`:

```swift
let navigator = ScreenNavigator()
let chatScreen = ChatScreen(chatID: 2)

navigator.navigate { route in
    route.last(.container(of: chatScreen))
}
```

To show the found screen, add the ``ScreenThenable/makeVisible(stackAnimation:tabsAnimation:dissmissAnimated:)`` method to the chain:

```swift
navigator.navigate { route in
    route
        .last(.container(of: chatScreen))
        .makeVisible()
}
```

This method will close the modal screen if needed, switch the tab and return the stack to the desired screen in the navigation controller. **Note** that this method will close the currently presented modal screen, which may have user input. In that case, navigate manually so that you don't lose the entered data.

### Updating data

To update the data on the screen after showing it, add a ``ScreenThenable/get(body:)-9ihbj`` method in which you can get a container with the type returned in the ``Screen`` factory:

```swift
navigator.navigate { route in
    route
        .last(.container(of: chatScreen))
        .makeVisible()
        .get { chatViewController in
            chatViewController.update(newMessage: "Hello 👋")
        }
}
```

Or you can use the ``ScreenThenable/refresh()`` method, but then the container must implement the ``ScreenRefreshableContainer`` protocol:

```swift
navigator.navigate { route in
    route
        .last(.container(of: chatScreen))
        .makeVisible()
        .refresh()
}
```

## Custom transitions

Nivelir allows you to navigate with custom animations. The following transitions can be animated:
- Replacing the root screen (``ScreenRootCustomAnimation``)
- Changing the navigation stack (``ScreenStackCustomAnimation``)
- Switching the tabs (``ScreenTabCustomAnimation``)
- Modal presentation ([UIViewControllerTransitioningDelegate](https://developer.apple.com/documentation/uikit/uiviewcontrollertransitioningdelegate))

Nivelir has prebuilt animations. For example, you can use ``ScreenRootAnimation/crossDissolve`` to replace the root screen:

```swift
func openHomeScreen() {
    navigator.navigate { route in
        route.setRoot(to: screens.homeScreen(), animation: .crossDissolve)
    }
}
```

To change the navigation stack, also use the `animation` parameter:

```swift
let container: UINavigationController

func showResumeEditScreen() {
    navigator.navigate(from: container) { route in
        route.replace(with: screens.resumeEditScreen(), animation: .crossDissolve)
    }
}
```

For custom modal present, the ``Screen/withModalTransitioningDelegate(_:)`` is used, where an instance of [UIViewControllerTransitioningDelegate](https://developer.apple.com/documentation/uikit/uiviewcontrollertransitioningdelegate) and [UIViewControllerAnimatedTransitioning](https://developer.apple.com/documentation/uikit/uiviewcontrolleranimatedtransitioning) (if needed) is passed to:

```swift
func showFloatingActionSheet() {
    navigator.navigate(from: container) { route in
        route.present(
            screens
                .floatingActionSheetScreen()
                .withModalTransitioningDelegate(CardModalTransitionAnimator())
        )
    }
}
```

## Working with DI

### Screens

Nivelir can easily be used in multi-module projects.

``Screen`` factories can be passed through DI by erasing their type using ``Screen/eraseToAnyScreen()``:

```swift
// A screen factory or any DI container where dependencies are registered
struct Screens {

    func homeScreen() -> AnyTabsScreen {
        HomeScreen(
            services: services,
            screens: self
        ).eraseToAnyScreen()
    }


    func roomListScreen() -> AnyModalScreen {
        RoomListScreen(
            services: services,
            screens: self
        ).eraseToAnyScreen()
    }
}
```

The erased factory screen holds the actual container type, so, for example, for ``AnyTabsScreen`` you can switch tabs, and for ``AnyStackScreen`` you can change the navigation stack.

You can also use ``Screen/eraseToAnyModalScreen()``, which erases the container type to `UIViewController`. So the container type does not extend beyond the module.

### Routes

``ScreenRoute`` that describe the navigation can also be shared between the modules of the application:

```swift
// A screen factory or any DI container where dependencies are registered
struct Screens {
    func showHomeRoute() -> ScreenWindowRoute {
        ScreenWindowRoute()
            .setRoot(to: homeScreen(), animation: .crossDissolve)
            .makeKeyAndVisible()
    }

    func showRoomListRoute() -> ScreenWindowRoute {
        ScreenWindowRoute()
            .last(.container(key: roomListScreen().key))
            .makeVisible()
            .fallback(to: showHomeRoute())
    }
}
```

At the point of use, pass ``ScreenRoute`` from the DI to the navigator, to perform navigation:

```swift
let screens: Screens
let navigator = ScreenNavigator()

navigator.navigate(to: screens.showRoomListRoute())
```

## Step-by-step migration

Screen factories must implement the ``Screen`` protocol to navigate and use all Nivelir features. It is recommended to start updating screen factories that do not depend on others. For compatibility with older factories, you can use an extension where the `UIViewController` will implement the ``Screen`` protocol:

```swift
extension ChatViewController: Screen { }

struct LegacyAssembly {
    func assembly(roomID: Int, chatID: Int) -> ChatViewController {
        ChatViewController(roomID: roomID, chatID: chatID)
    }
}

let screen = LegacyAssembly()
    .assembly(roomID: 1, chatID: 1)
    .eraseToAnyModalScreen()

navigator.navigate(from: container) { route in
    route.present(screen)
}
```

## Dismiss and push

An example of a navigation chain where an application has a `UITabBarController` with navigation controllers in tabs and a modally presented screen. This example demonstrates how to close the modally presented screen and push a new screen to the navigation stack below it:

```swift
// Modally presented container
let container: UIViewController?

func showChat(withID chatID: String) {
    navigator.navigate(from: container?.presenting) { route in // 1
        route
            .dismiss() // 2
            .top(.stack) // 3
            .push(screens.chatScreen(chatID: chatID)) // 4
    }
}
```

1. Get the container that presents this screen modally (in our case it will be the `UITabBarController`).
2. Close the screen presented modally. Note that the ``ScreenThenable/dismiss(animated:)`` action closes only the presented screen, unlike as the `dismiss(animated:completion:)` method of the `UIViewController`.
3. Search for the top `UINavigationController` with action ``ScreenThenable/top(_:)``. In our case it will be the controller that was under the screen.
4. Push a new screen to the found navigation controller with the action ``ScreenThenable/push(_:animation:separated:)``.
