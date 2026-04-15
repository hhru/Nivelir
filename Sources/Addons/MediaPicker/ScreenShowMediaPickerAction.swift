#if canImport(UIKit) && canImport(Photos) && canImport(AVFoundation) && os(iOS) && !targetEnvironment(macCatalyst)
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

    @MainActor
    private func requestPhotosAccess() async throws {
        if #available(iOS 14, *) {
            await PHPhotoLibrary.requestAuthorization(for: .readWrite)
        } else {
            try? await withCheckedThrowingContinuation { continuation in
                PHPhotoLibrary.requestAuthorization { _ in
                    continuation.resume()
                }
            }
        }

        try await requestPhotosAccessIfNeeded(isRequested: true)
    }

    @MainActor
    private func requestPhotosAccessIfNeeded(isRequested: Bool = false) async throws {
        let authorizationStatus: PHAuthorizationStatus

        if #available(iOS 14, *) {
            authorizationStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        } else {
            authorizationStatus = PHPhotoLibrary.authorizationStatus()
        }

        switch authorizationStatus {
        case .notDetermined:
            try await requestPhotosAccess()

        case .authorized, .limited:
            break

        case .denied, .restricted:
            throw MediaPickerSourceAccessDeniedError(
                for: self,
                isRequested: isRequested
            )

        @unknown default:
            throw MediaPickerSourceAccessDeniedError(
                for: self,
                isRequested: isRequested
            )
        }
    }

    @MainActor
    private func requestCameraAccess() async throws {
        await AVCaptureDevice.requestAccess(for: .video)

        try await requestCameraAccessIfNeeded(isRequested: true)
    }

    @MainActor
    private func requestCameraAccessIfNeeded(isRequested: Bool = false) async throws {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            try await requestCameraAccess()

        case .authorized:
            break

        case .denied, .restricted:
            throw MediaPickerSourceAccessDeniedError(
                for: self,
                isRequested: isRequested
            )

        @unknown default:
            throw MediaPickerSourceAccessDeniedError(
                for: self,
                isRequested: isRequested
            )
        }
    }

    @MainActor
    private func requestAccessIfNeeded() async throws {
        switch mediaPicker.source {
        case .photoLibrary, .savedPhotosAlbum:
            try await requestPhotosAccessIfNeeded()

        case .camera:
            try await requestCameraAccessIfNeeded()
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

        Task { @MainActor in
            do {
                try await requestAccessIfNeeded()
            } catch {
                return completion(.failure(error))
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
