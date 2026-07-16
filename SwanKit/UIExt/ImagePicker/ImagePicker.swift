//
//  ImagePicker.swift
//  SwanKit
//
//  Created by Stanislav Pletnev on 2026-07-16.
//  Copyright © 2026 Anobisoft. Licensed under the MIT License.
//

import UIKit
import PhotosUI
import SwanKitFoundation

/// A MainActor-isolated micro-framework manager orchestrating raw system media acquisition events.
///
/// `ImagePicker` serves as a unified, high-level facade layer hiding the complexities of interfacing
/// with legacy `UIImagePickerController` hardware streams and modern `PHPickerViewController` asset catalog configurations.
///
/// ### Core Responsibilities:
/// - **Permission Management:** Automatically intercepts presentation loops to validate system privacy clear tokens before spawning viewports.
/// - **Deep-Link Redirections:** Gracefully bounces user interactions directly into native system settings boards if permissions are denied.
/// - **Concurrency Compliance:** Bridges asynchronous execution pipelines natively via modern `async/await` mechanics.
///
/// ### Example Usage:
/// ```swift
/// let picker = ImagePicker()
///
/// await picker.presentLibrary(on: self, with: .init(selectionLimit: 0)) { result in
///     switch result {
///     case .pickerMultiple(let phResults):
///         print("Batch selected \(phResults.count) items")
///     case .cancelled:
///         print("User aborted configuration session")
///     default:
///         break
///     }
/// }
/// ```
@MainActor
public final class ImagePicker {

    /// The unified completion block delivering the resulting transaction state payload.
    ///
    /// This callback is guaranteed to execute back on the `@MainActor` boundary, ensuring complete thread-safety
    /// when mutating downstream user interface layouts or data stores.
    public typealias Handler = @MainActor (PickerResult) -> Void

    // MARK: - Transaction State Result

    /// A strongly typed transactional state result representing explicitly how a media capture or library selection sequence was concluded.
    ///
    /// This enum is marked as `Sendable` to safely cross structured asynchronous architecture threads.
    public enum PickerResult: Sendable {

        /// The transaction was explicitly aborted or canceled by the user layouts.
        case cancelled

        /// A single confirmed image asset captured via native camera hardware devices (handles edited cuts automatically).
        ///
        /// - Parameter image: The raw or cropped `UIImage` instance acquired directly from the device lens context.
        case camera(UIImage)

        /// A single atomic photo catalog selection package containing a singular raw system result wrapper.
        ///
        /// - Parameter result: The native PhotosUI metadata packet returned for single selections.
        case pickerSingle(PHPickerResult)

        /// A collection sequence containing multiple raw system asset result elements.
        ///
        /// - Parameter results: The array of native PhotosUI metadata packets returned during multi-selection streams.
        case pickerMultiple([PHPickerResult])
    }

    /// Instantiates a new, standalone `ImagePicker` coordinator node.
    public init() {}

    /// The active retain hook reference anchoring internal delegate callbacks safely across systemic presentation loops.
    private var activeDelegate: Delegate?

    // MARK: - Presentation Layer

    /// Instantly bridges and triggers a standard system camera capture viewport using explicit camera specifications.
    ///
    /// This method is entirely asynchronous and non-blocking. It checks low-level hardware availability and camera access permissions
    /// before performing the modal presentation transition.
    ///
    /// - Parameters:
    ///   - viewController: The target view controller anchoring the presentation layer loop.
    ///   - config: The structured specifications mapping properties applied onto the camera device. Defaults to `.default`.
    ///   - handler: The delivery callback receiving the resulting structural ``PickerResult`` state.
    public func presentCameraCapture(
        on viewController: UIViewController,
        with config: CameraConfig = .default,
        completion handler: @escaping Handler
    ) async {
        guard await checkCameraAccess(), UIImagePickerController.isSourceTypeAvailable(.camera) else {
            handler(.cancelled)
            return
        }

        let picker = UIImagePickerController()
        let delegate = Delegate(retainer: self, presenter: picker, handler: handler)

        self.activeDelegate = delegate
        picker.delegate = delegate
        picker.sourceType = .camera
        picker.allowsEditing = config.allowsEditing
        picker.cameraDevice = config.cameraDevice
        picker.cameraFlashMode = config.cameraFlashMode

        viewController.present(picker, animated: true)
    }

    /// Instantly interfaces and presents a modern photo library catalog picker layout canvas using explicit library constraints.
    ///
    /// This method evaluates local Photos framework authorization states dynamically before loading the user selection canvas sheets.
    ///
    /// - Parameters:
    ///   - viewController: The target view controller anchoring presentation loops.
    ///   - config: The structured specifications detailing library selection boundaries. Defaults to `.default`.
    ///   - handler: The callback delivering processed result payloads.
    public func presentLibrary(
        on viewController: UIViewController,
        with config: LibraryConfig = .default,
        completion handler: @escaping Handler
    ) async {
        guard await checkPhotoLibraryAccess() else {
            handler(.cancelled)
            return
        }

        var phConfig = PHPickerConfiguration()
        phConfig.filter = .images
        phConfig.selectionLimit = config.selectionLimit

        let picker = PHPickerViewController(configuration: phConfig)
        let delegate = Delegate(retainer: self, presenter: picker, handler: handler)

        self.activeDelegate = delegate
        picker.delegate = delegate

        viewController.present(picker, animated: true)
    }
}

// MARK: - Private Extensions

private extension ImagePicker {

    /// Internal hardware privacy clearance evaluation pipeline.
    ///
    /// Automatically requests camera video track capabilities and maps deep-link preference panel routes if denied.
    func checkCameraAccess() async -> Bool {
        let granted = await Access.Capture.Video.requestAccess()
        if !granted {
            Access.Capture.Video.openSettings()
        }
        return granted
    }

    /// Internal photo library privacy depth verification pipeline.
    ///
    /// Evaluates read-write catalog access tokens and performs automated system preference jumps upon denials.
    func checkPhotoLibraryAccess() async -> Bool {
        let status = await Access.PhotoLibrary.requestAccess(level: .readWrite)

        switch status {
        case .authorized, .limited:
            return true
        default:
            Access.PhotoLibrary.openSettings()
            return false
        }
    }
}

// Retroactively inject strict compiler-level concurrency approval flags onto the legacy system result metadata class
extension PHPickerResult: @unchecked @retroactive Sendable {}
