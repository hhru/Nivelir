import SwiftUI
import Nivelir

struct LandmarkScreen: Screen {

    func build(navigator: ScreenNavigator) -> UIViewController {
        UIHostingController(rootView: LandmarkView())
    }
}
