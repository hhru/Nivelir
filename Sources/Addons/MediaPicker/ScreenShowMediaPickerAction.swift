#if canImport(UIKit) && canImport(Photos) && canImport(AVFoundation) && os(iOS)
import UIKit
import Photos
import AVFoundation

/// Action to show the `UIImagePickerController`.
public struct ScreenShowMediaPickerAction<Container: UIViewController>: ScreenAction {

    public typealias Output = UIImagePickerController

    public let mediaPicker: MediaPicker
    public let animated: Bool

    public init(
        mediaPicker: MediaPicker,
        animated: Bool = true
    ) {
        self.mediaPicker = mediaPicker
        self.animated = animated
    }

    private func requestPhotosAccess(completion: @escaping (_ authorized: Bool) -> Void) {
        let handler: (PHAuthorizationStatus) -> Void = { _ in
            DispatchQueue.main.async {
                requestPhotosAccessIfNeeded(completion: completion)
            }
        }

        if #available(iOS 14, *) {
            PHPhotoLibrary.requestAuthorization(for: .readWrite, handler: handler)
        } else {
            PHPhotoLibrary.requestAuthorization(handler)
        }
    }

    private func requestPhotosAccessIfNeeded(completion: @escaping (_ authorized: Bool) -> Void) {
        let authorizationStatus: PHAuthorizationStatus

        if #available(iOS 14, *) {
            authorizationStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        } else {
            authorizationStatus = PHPhotoLibrary.authorizationStatus()
        }

        switch authorizationStatus {
        case .authorized, .limited:
            completion(true)

        case .denied, .restricted:
            completion(false)

        case .notDetermined:
            requestPhotosAccess(completion: completion)

        @unknown default:
            completion(false)
        }
    }

    private func requestCameraAccess(completion: @escaping (_ authorized: Bool) -> Void) {
        AVCaptureDevice.requestAccess(for: .video) { _ in
            DispatchQueue.main.async {
                requestCameraAccessIfNeeded(completion: completion)
            }
        }
    }

    private func requestCameraAccessIfNeeded(completion: @escaping (_ authorized: Bool) -> Void) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            completion(true)

        case .denied, .restricted:
            completion(false)

        case .notDetermined:
            requestCameraAccess(completion: completion)

        @unknown default:
            completion(false)
        }
    }

    private func requestAccessIfNeeded(completion: @escaping (_ authorized: Bool) -> Void) {
        switch mediaPicker.source {
        case .photoLibrary, .savedPhotosAlbum:
            requestPhotosAccessIfNeeded(completion: completion)

        case .camera:
            requestCameraAccessIfNeeded(completion: completion)
        }
    }

    private func makeImagePickerContainer(availableTypes: [MediaPickerType]) -> UIImagePickerController {
        let mediaPickerContainer = UIImagePickerController()
        let mediaPickerManager = MediaPickerManager(mediaPicker: mediaPicker)

        mediaPicker.didInitialize?(mediaPickerContainer)

        mediaPickerContainer.screenPayload.store(mediaPickerManager)
        mediaPickerContainer.delegate = mediaPickerManager

        switch mediaPicker.source {
        case let .camera(settings: cameraSettings):
            mediaPickerContainer.sourceType = .camera
            mediaPickerContainer.cameraDevice = cameraSettings.device
            mediaPickerContainer.cameraCaptureMode = cameraSettings.captureMode
            mediaPickerContainer.cameraFlashMode = cameraSettings.flashMode

        case .photoLibrary:
            mediaPickerContainer.sourceType = .photoLibrary

        case .savedPhotosAlbum:
            mediaPickerContainer.sourceType = .savedPhotosAlbum
        }

        mediaPickerContainer.allowsEditing = mediaPicker.allowsEditing
        mediaPickerContainer.mediaTypes = availableTypes.map { $0.rawValue }

        if #available(iOS 11.0, *) {
            switch mediaPicker.imageExportPreset {
            case .current:
                mediaPickerContainer.imageExportPreset = .current

            case .compatible:
                mediaPickerContainer.imageExportPreset = .compatible
            }

            if let videoExportPreset = mediaPicker.videoExportPreset {
                mediaPickerContainer.videoExportPreset = videoExportPreset
            }
        }

        mediaPickerContainer.videoMaximumDuration = mediaPicker.videoMaximumDuration
        mediaPickerContainer.videoQuality = mediaPicker.videoQuality

        return mediaPickerContainer
    }

    public func perform(
        container: Container,
        navigator: ScreenNavigator,
        completion: @escaping Completion
    ) {
        navigator.logInfo("Presenting \(mediaPicker) on \(type(of: container))")

        guard container.presented == nil else {
            return completion(.containerAlreadyPresenting(container, for: self))
        }

        requestAccessIfNeeded { authorized in
            guard authorized else {
                return completion(.mediaPickerSourceAccessDenied(for: self))
            }

            guard mediaPicker.source.isAvailable else {
                return completion(.unavailableMediaPickerSource(for: self))
            }

            let availableTypes = mediaPicker
                .source
                .availableMediaTypes
                .filter(mediaPicker.types.contains)

            guard !availableTypes.isEmpty else {
                return completion(.unavailableMediaPickerTypes(for: self))
            }

            let mediaPickerContainer = makeImagePickerContainer(availableTypes: availableTypes)

            container.present(mediaPickerContainer, animated: animated) {
                completion(.success(mediaPickerContainer))
            }
        }
    }
}

extension ScreenThenable where Current: UIViewController {

    /// Displays the view controller that manages the system interfaces for taking pictures,
    /// recording movies, and choosing items from the user's media library.
    ///
    /// To use this method, you must provide a ``MediaPicker`` configuration object via parameters.
    /// The media file selection result is called by a closure ``MediaPicker/didFinish``,
    /// where you will be able to close the controller via ``dismiss(animated:)`` if needed.
    ///
    /// - Parameters:
    ///   - mediaPicker: Object for configuring the display and handling of events.
    ///   - animated: Pass `true` to animate the presentation; otherwise, pass `false`.
    ///   - route: Nested route to be performed in the `UIImagePickerController`.
    /// - Returns: An instance containing the new action.
    public func showMediaPicker<Route: ScreenThenable>(
        _ mediaPicker: MediaPicker,
        animated: Bool = true,
        route: Route
    ) -> Self where Route.Root == UIImagePickerController {
        fold(
            action: ScreenShowMediaPickerAction<Current>(
                mediaPicker: mediaPicker,
                animated: animated
            ),
            nested: route
        )
    }

    /// Displays the view controller that manages the system interfaces for taking pictures,
    /// recording movies, and choosing items from the user's media library.
    ///
    /// To use this method, you must provide a ``MediaPicker`` configuration object via parameters.
    /// The media file selection result is called by a closure ``MediaPicker/didFinish``,
    /// where you will be able to close the controller via ``dismiss(animated:)`` if needed.
    ///
    /// - Parameters:
    ///   - mediaPicker: Object for configuring the display and handling of events.
    ///   - animated: Pass `true` to animate the presentation; otherwise, pass `false`.
    ///   - route: Nested route to be performed in the `UIImagePickerController`.
    /// - Returns: An instance containing the new action.
    public func showMediaPicker(
        _ mediaPicker: MediaPicker,
        animated: Bool = true,
        route: (
            _ route: ScreenRootRoute<UIImagePickerController>
        ) -> ScreenRouteConvertible = { $0 }
    ) -> Self {
        showMediaPicker(
            mediaPicker,
            animated: animated,
            route: route(.initial).route()
        )
    }
}
#endif
