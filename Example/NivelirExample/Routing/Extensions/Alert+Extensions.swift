import UIKit
import Nivelir

extension Alert {

    static let somethingWentWrong = Self(
        title: "Error",
        message: """
            Something went wrong.
            """,
        actions: AlertAction(title: "OK")
    )

    static let unavailableMediaTypes = Self(
        title: "Error",
        message: """
            Your device does not support the required media types.
            """,
        actions: AlertAction(title: "OK")
    )

    static let unavailableMediaSource = Self(
        title: "Error",
        message: """
            Your device does not support the selected media source.
            """,
        actions: AlertAction(title: "OK")
    )

    static let photoLibraryPermissionRequired = Self(
        title: "Permission Required",
        message: """
            The app needs permission to access your photo library to select a photo. \
            Please go to Setting > Privacy > Photos and enable Nivelir Example.
            """,
        actions: [
            AlertAction(title: "Not Now"),
            AlertAction(title: "Open Settings") {
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsURL)
                }
            }
        ]
    )

    static let cameraPermissionRequired = Self(
        title: "Permission Required",
        message: """
            The app needs permission to access your device's camera to take a photo. \
            Please go to Setting > Privacy > Camera, and enable Nivelir Example.
            """,
        actions: [
            AlertAction(title: "Not Now"),
            AlertAction(title: "Open Settings") {
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsURL)
                }
            }
        ]
    )
}
