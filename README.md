# Nivelir
[![Build Status](https://github.com/hhru/Nivelir/workflows/CI/badge.svg?branch=main)](https://github.com/hhru/Nivelir/actions)
[![Cocoapods](https://img.shields.io/cocoapods/v/Nivelir.svg?style=flat)](http://cocoapods.org/pods/Nivelir)
[![Carthage compatible](https://img.shields.io/badge/Carthage-Compatible-brightgreen.svg?style=flat)](https://github.com/Carthage/Carthage)
[![SPM compatible](https://img.shields.io/badge/SPM-Compatible-brightgreen.svg?style=flat)](https://swift.org/package-manager/)
[![Platforms](https://img.shields.io/cocoapods/p/Nivelir.svg?style=flat)](https://developer.apple.com/discover/)
[![Xcode](https://img.shields.io/badge/Xcode-11-blue.svg)](https://developer.apple.com/xcode)
[![Swift](https://img.shields.io/badge/Swift-5.1-orange.svg)](https://swift.org)
[![License](https://img.shields.io/github/license/hhru/Nivelir.svg)](https://opensource.org/licenses/MIT)

Nivelir is a DSL for navigation in iOS and tvOS apps with a simplified, chainable, and compile time safe syntax.


## Contents
- [Requirements](#requirements)
- [Installation](#installation)
    - [CocoaPods](#cocoapods)
    - [Carthage](#carthage)
    - [Swift Package Manager](#swift-package-manager)
- [Usage](#usage)
    - [Quick Start](#quick-start)
    - [Example App](#example-app)
- [Articles](#articles)
- [Communication](#communication)
- [License](#license)


## Requirements
- iOS 10.0+ / tvOS 10.0+
- Xcode 11+
- Swift 5.1+


## Installation
### CocoaPods
[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:
``` bash
$ gem install cocoapods
```

To integrate Nivelir into your Xcode project using [CocoaPods](http://cocoapods.org), specify it in your `Podfile`:
``` ruby
platform :ios, '10.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'Nivelir', '~> 1.2.2'
end
```

Finally run the following command:
``` bash
$ pod install
```

### Carthage
[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks. You can install Carthage with Homebrew using the following command:
``` sh
$ brew update
$ brew install carthage
```

To integrate Nivelir into your Xcode project using Carthage, specify it in your `Cartfile`:
``` ogdl
github "hhru/Nivelir" ~> 1.2.2
```

Finally run `carthage update` to build the framework and drag the built `Nivelir.framework` into your Xcode project.

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for managing the distribution of Swift code. It’s integrated with the Swift build system to automate the process of downloading, compiling, and linking dependencies.

To integrate Nivelir into your Xcode project using Swift Package Manager,
add the following as a dependency to your `Package.swift`:
``` swift
.package(url: "https://github.com/hhru/Nivelir.git", from: "1.2.2")
```
Then specify `"Nivelir"` as a dependency of the Target in which you wish to use Nivelir.

Here's an example `Package.swift`:
``` swift
// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "MyPackage",
    products: [
        .library(name: "MyPackage", targets: ["MyPackage"])
    ],
    dependencies: [
        .package(url: "https://github.com/hhru/Nivelir.git", from: "1.2.2")
    ],
    targets: [
        .target(name: "MyPackage", dependencies: ["Nivelir"])
    ]
)
```


## Usage

[API Documentation](http://tech.hh.ru/Nivelir/)

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
[Example app](Example) is a simple iOS and tvOS app that demonstrates how Nivelir works in practice.
It's also a good place to start playing with the framework.

To install it, run these commands in a terminal:

``` sh
$ git clone https://github.com/hhru/Nivelir.git
$ cd Nivelir/Example
$ pod install
$ open NivelirExample.xcworkspace
```


## Articles
Russian:
- [Nivelir: Удобный DSL для навигации](https://habr.com/ru/company/hh/blog/572488/)


## Communication
- If you need help, open an issue.
- If you found a bug, open an issue.
- If you have a feature request, open an issue.
- If you want to contribute, submit a pull request.

📬 You can also write to us in telegram, we will help you: https://t.me/hh_tech


## License
Nivelir is available under the MIT license. See the [LICENSE](LICENSE) file for more info.
