import UIKit
import Nivelir

extension HUD {

    static var spinner: Self {
        spinner(
            ProgressSpinnerIndicator(color: Colors.important),
            message: ProgressMessageFooter(text: "Please wait...", color: Colors.title)
        )
    }

    static var success: Self {
        success(ProgressSuccessIndicator(color: Colors.important))
    }

    static var failure: Self {
        failure(ProgressFailureIndicator(color: Colors.important))
    }

    static func percentage(ratio: CGFloat) -> Self {
        percentage(ProgressPercentageIndicator(ratio: ratio, color: Colors.important))
    }
}
