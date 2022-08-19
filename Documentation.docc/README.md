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

### Screen

- ``Screen``
- ``ScreenContainer``
- ``ScreenKey``
- ``ScreenKeyedContainer``
- ``ScreenVisibleContainer``
- ``ScreenIterableContainer``
- ``ScreenPayload``
- ``ScreenPayloadedContainer``
- ``AnyScreen``
- ``AnyModalScreen``
- ``AnyStackScreen``
- ``AnyTabsScreen``

### Route

- ``ScreenThenable``
- ``ScreenRoute``
- ``ScreenRouteConvertible``
- ``ScreenRootRoute``
- ``ScreenModalRoute``
- ``ScreenStackRoute``
- ``ScreenTabsRoute``
- ``ScreenWindowRoute``

### Actions

- ``ScreenAction``
- ``ScreenActionStorage``
- ``AnyScreenAction``

- ``ScreenFailAction``
- ``ScreenFoldAction``
- ``ScreenFromAction``
- ``ScreenGetAction``
- ``ScreenMakeVisibleAction``
- ``ScreenNavigateAction``
- ``ScreenWaitAction``

- ``ScreenPredicate``
- ``ScreenFirstAction``
- ``ScreenLastAction``
- ``ScreenTopAction``

- ``ScreenRefreshAction``
- ``ScreenRefreshableContainer``

- ``ScreenTryAction``
- ``ScreenTryResolution``

- ``ScreenDismissAction``
- ``ScreenPresentAction``
- ``ScreenPresentedAction``
- ``ScreenPresentingAction``
- ``ScreenStackAction``
- ``ScreenTabsAction``
- ``ScreenWindowAction``

- ``ScreenSetStackAction``
- ``ScreenStackModifier``
- ``ScreenStackClearModifier``
- ``ScreenStackPushModifier``
- ``ScreenStackReplaceModifier``
- ``ScreenStackPopModifier``
- ``ScreenStackPopPredicate``
- ``ScreenStackAnimation``
- ``ScreenStackCustomAnimation``
- ``ScreenStackTransitionAnimation``
- ``ScreenStackRootAction``
- ``ScreenStackTopAction``
- ``ScreenStackVisibleAction``

- ``ScreenSelectTabAction``
- ``ScreenTabAnimation``
- ``ScreenTabCustomAnimation``
- ``ScreenTabTransitionAnimation``
- ``ScreenTabPredicate``
- ``ScreenSelectedTabAction``
- ``ScreenSetupTabAction``

- ``ScreenMakeKeyAction``
- ``ScreenMakeKeyAndVisibleAction``
- ``ScreenRootAction``
- ``ScreenSetRootAction``
- ``ScreenRootAnimation``
- ``ScreenRootCustomAnimation``
- ``ScreenRootTransitionAnimation``

### Decorators

- ``ScreenDecorator``

- ``ScreenLeftBarButtonDecorator``
- ``ScreenModalStyleDecorator``
- ``ScreenModalStyle``
- ``ScreenPopoverPresentationAnchor``
- ``ScreenPopoverPresentationDecorator``
- ``ScreenRightBarButtonDecorator``
- ``ScreenStackContainerDecorator``

- ``ScreenStackDecorator``

- ``ScreenTabBarItemDecorator``
- ``ScreenTabsDecorator``

### Errors

- ``ScreenError``
- ``ScreenCanceledError``
- ``ScreenContainerNotFoundError``
- ``ScreenContainerNotSupportedError``
- ``ScreenContainerTypeMismatchError``

### Observation

- ``ScreenObservation``
- ``ScreenObserver``
- ``ScreenObserverPredicate``
- ``ScreenObserverToken``

### Navigator

- ``ScreenNavigator``
- ``ScreenLogger``
- ``DefaultScreenLogger``
- ``ScreenIterator``
- ``DefaultScreenIterator``
- ``ScreenIterationResult``
- ``ScreenIterationPredicate``
- ``ScreenWindowProvider``
- ``ScreenKeyWindowProvider``
- ``ScreenCustomWindowProvider``
- ``ScreenObservatory``
- ``DefaultScreenObservatory``

### Deeplink

- ``Deeplink``
- ``AnyDeeplink``
- ``DeeplinkManager``
- ``DeeplinkHandler``
- ``DeeplinkScope``
- ``DeeplinkType``
- ``DeeplinkInterceptor``

- ``DeeplinkError``
- ``DeeplinkInvalidContextError``
- ``DeeplinkInvalidScreensError``

- ``NotificationDeeplink``
- ``NotificationDeeplinkUserInfoDecoder``
- ``NotificationDeeplinkUserInfoOptions``
- ``AnyNotificationDeeplink``
- ``NotificationDeeplinkInvalidUserInfoError``

- ``ShortcutDeeplink``
- ``ShortcutDeeplinkUserInfoDecoder``
- ``ShortcutDeeplinkUserInfoOptions``
- ``AnyShortcutDeeplink``

- ``URLDeeplink``
- ``URLDeeplinkQueryDecoder``
- ``URLDeeplinkQueryOptions``
- ``AnyURLDeeplink``
- ``URLDeeplinkInvalidComponentsError``

### Deeplink Decoding Strategy

- ``DictionaryDataDecodingStrategy``
- ``DictionaryDateDecodingStrategy``
- ``DictionaryKeyDecodingStrategy``
- ``DictionaryNonConformingFloatDecodingStrategy``

- ``URLQueryDataDecodingStrategy``
- ``URLQueryDateDecodingStrategy``
- ``URLQueryKeyDecodingStrategy``
- ``URLQueryNonConformingFloatDecodingStrategy``

### ActionSheet

- ``ActionSheet``
- ``ActionSheetAction``
- ``ScreenShowActionSheetAction``

### Alert

- ``Alert``
- ``AlertAction``
- ``AlertTextField``
- ``ScreenShowAlertAction``

### DocumentPreview

- ``DocumentPreview``
- ``DocumentPreviewAnchor``
- ``ScreenShowDocumentPreviewAction``

### Haptics

- ``ScreenImpactOccurredAction``
- ``ScreenNotificationOccurredAction``
- ``ScreenSelectionChangedAction``

### HUD

- ``HUD``
- ``HUDStyle``
- ``HUDAnimation``
- ``HUDCustomAnimation``
- ``HUDDefaultAnimation``
- ``ScreenHideHUDAction``
- ``ScreenShowHUDAction``

- ``Progress``
- ``ProgressView``

- ``ProgressAnimation``
- ``ProgressCustomAnimation``
- ``ProgressDefaultAnimation``

- ``AnyProgressContent``
- ``ProgressContent``
- ``ProgressContentView``

- ``ProgressHeader``
- ``ProgressEmptyHeader``
- ``ProgressEmptyHeaderView``

- ``ProgressFooter``
- ``ProgressMessageFooter``
- ``ProgressMessageFooterView``
- ``ProgressEmptyFooter``
- ``ProgressEmptyFooterView``

- ``ProgressIndicator``
- ``ProgressActivityIndicator``
- ``ProgressActivityIndicatorView``
- ``ProgressFailureIndicator``
- ``ProgressFailureIndicatorView``
- ``ProgressImageIndicator``
- ``ProgressImageIndicatorView``
- ``ProgressPercentageIndicator``
- ``ProgressPercentageIndicatorView``
- ``ProgressSpinnerIndicator``
- ``ProgressSpinnerIndicatorView``
- ``ProgressSuccessIndicator``
- ``ProgressSuccessIndicatorView``

### MediaPicker

- ``MediaPicker``
- ``MediaPickerSource``
- ``MediaPickerType``
- ``MediaPickerCameraSettings``
- ``MediaPickerImageExportPreset``
- ``MediaPickerResult``
- ``ScreenShowMediaPickerAction``
- ``MediaPickerSourceAccessDeniedError``
- ``UnavailableMediaPickerSourceError``
- ``UnavailableMediaPickerTypesError``

### Safari

- ``Safari``
- ``ScreenShowSafariAction``
- ``InvalidSafariURLError``

### Sharing

- ``Sharing``
- ``SharingItem``
- ``SharingCustomItem``
- ``SharingActivity``
- ``SharingActivityCategory``
- ``SharingActivityType``
- ``SharingCustomActivity``
- ``SharingSilentActivity``
- ``SharingVisualActivity``
- ``ScreenShareAction``

### StoreProduct

- ``StoreProduct``
- ``ScreenShowStoreProductAction``
- ``InvalidStoreProductIDError``

### StoreReview

- ``ScreenRequestStoreReviewAction``

### URL

- ``ScreenOpenURLAction``
- ``FailedToOpenURLError``

### Call

- ``ScreenCallAction``
- ``InvalidCallParametersError``

### Mail

- ``ScreenMailAction``
- ``InvalidMailParametersError``

### OpenSettings

- ``ScreenOpenSettingsAction``
- ``InvalidOpenSettingsURLError``

### OpenStoreApp

- ``ScreenOpenStoreAppAction``
- ``InvalidStoreAppIDError``
