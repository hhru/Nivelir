# ``Nivelir``

A Swift DSL for navigation in iOS and tvOS apps with a simplified, chainable, and compile time safe syntax.

## Overview

Nivelir is a DSL for navigation in iOS and tvOS apps with a simplified, chainable, and compile time safe syntax.

### Quick Start

Let's implement a simple view controller that can set the background color:

``` swift
class SomeViewController: UIViewController {

    let color: UIColor

    init(color: UIColor) {
        self.color = color

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = color
    }
}
```

Next, we need to implement a builder that creates our controller:

``` swift
struct SomeScreen: Screen {

    let color: UIColor

    func build(navigator: ScreenNavigator) -> UIViewController {
        SomeViewController(color: color)
    }
}
```

Now we can use this screen for navigation:

``` swift
let navigator = ScreenNavigator()

navigator.navigate { route in
    route
        .top(.stack)
        .popToRoot()
        .push(SomeScreen(color: .red))
        .push(SomeScreen(color: .green)) { route in
            route.present(SomeScreen(color: .blue))
        }
}
```

This navigation performs the following steps:
- Search for the topmost container of the stack (`UINavigationController`)
- Resetting its stack to the first screen
- Adding a red screen to the stack
- Adding a green screen to the stack
- Presenting a blue screen on the green screen modally


### Example App
[Example app](https://github.com/hhru/Nivelir/tree/main/Example) is a simple iOS and tvOS app that demonstrates how Nivelir works in practice.
It's also a good place to start playing with the framework.

To install it, run these commands in a terminal:

``` sh
$ git clone https://github.com/hhru/Nivelir.git
$ cd Nivelir/Example
$ pod install
$ open NivelirExample.xcworkspace
```


## Articles and Videos
You can learn more about Nivelir through our articles and videos.

### Articles
- [EN] [Nivelir: a convenient DSL for navigation](https://medium.com/hh-ru/nivelir-b6c550332971)
- [RU] [Nivelir: Удобный DSL для навигации](https://habr.com/ru/company/hh/blog/572488/)

### Videos
- [RU] [Обзор решений для навигации в iOS. Предпосылки Nivelir](https://youtu.be/FjAwpocB6rA)
- [RU] [Гибкая навигации в iOS. Nivelir](https://youtu.be/GcPTi8-WIn8)

## Topics

### Basics

- ``Screen``
- ``ScreenAction``
- ``ScreenNavigator``
- <doc:CheatSheet>

### Deeplinking

- ``Deeplink``
- ``DeeplinkManager``
- ``URLDeeplink``
- ``NotificationDeeplink``
- ``ShortcutDeeplink``

### Addons actions

- ``ScreenThenable/showActionSheet(_:animated:)``
- ``ScreenThenable/showAlert(_:animated:)``
- ``ScreenThenable/showDocumentPreview(_:animated:route:)-5m2np``
- ``ScreenThenable/impactOccurred(style:)``
- ``ScreenThenable/impactOccurred(intensity:)``
- ``ScreenThenable/notificationOccurred(type:)``
- ``ScreenThenable/selectionChanged()``
- ``ScreenThenable/showMediaPicker(_:animated:route:)-6tfor``
- ``ScreenThenable/showSafari(_:animated:route:)-2nik6``
- ``ScreenThenable/share(_:animated:route:)-go01``
- ``ScreenThenable/showStoreProduct(_:animated:route:)-87uaq``
- ``ScreenThenable/requestStoreReview()``

### HUD

- ``HUD``
- ``ScreenThenable/showHUD(_:animation:duration:)``
- ``ScreenThenable/hideHUD()``

### Working with URL

- ``ScreenThenable/call(to:)``
- ``ScreenThenable/mail(to:subject:body:)``
- ``ScreenThenable/openAppSettings()``
- ``ScreenThenable/openStoreApp(id:forReview:)``
- ``ScreenThenable/openURL(_:fallbackURLs:options:)``
