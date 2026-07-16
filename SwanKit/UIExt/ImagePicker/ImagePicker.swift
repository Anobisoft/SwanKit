//
//  ImagePicker.swift
//  SwanKit
//
//  Created by Stanislav Pletnev on 2026-07-16.
//  Copyright © 2026 Anobisoft. Licensed under the MIT License.
//

import UIKit
import PhotosUI

/// A MainActor-isolated micro-framework manager orchestrating raw system media acquisition events.
@MainActor
public final class ImagePicker {

    // MARK: - Dedicated Configurations

    /// A configuration blueprint grouping explicit operational metrics required for hardware camera captures.
    public struct CameraConfig: Sendable {
        public var allowsEditing: Bool
        public var cameraDevice: UIImagePickerController.CameraDevice
        public var cameraFlashMode: UIImagePickerController.CameraFlashMode

        public init(
            allowsEditing: Bool = false,
            cameraDevice: UIImagePickerController.CameraDevice = .rear,
            cameraFlashMode: UIImagePickerController.CameraFlashMode = .auto
        ) {
            self.allowsEditing = allowsEditing
            self.cameraDevice = cameraDevice
            self.cameraFlashMode = cameraFlashMode
        }

        /// Standard default configuration for active camera hardware: rear lens, flash auto, editing disabled.
        public static let `default` = CameraConfig()
    }

    /// A configuration blueprint detailing structural selection constraints applied onto photo library workflows.
    public struct LibraryConfig: Sendable {
        /// The maximum number of distinct assets a user can select inside the library catalog gallery picker.
        /// Set to `1` for single choices or `0` for unlimited multi-selection. Defaults to `1`.
        public var selectionLimit: Int

        public init(selectionLimit: Int = 1) {
            self.selectionLimit = selectionLimit
        }

        /// Standard default configuration for gallery picker interfaces: single item selection framework constraint.
        public static let `default` = LibraryConfig()
    }

    // MARK: - Transaction State Result

    /// A strongly typed transactional state result representing explicitly how a media capture or library selection sequence was concluded.
    ///
    /// ИСПРАВЛЕНО: Переименовано в PickerResult во избежание конфликтов имен со стандартным типом Swift.Result.
    public enum PickerResult: Sendable {
        /// The transaction was explicitly aborted or canceled by the user layouts.
        case cancelled

        /// A single confirmed image asset captured via native camera hardware devices (handles edited cuts automatically).
        case camera(UIImage)

        /// A single atomic photo catalog selection package containing a singular raw system result wrapper.
        case pickerSingle(PHPickerResult)

        /// A collection sequence containing multiple raw system asset result elements.
        case pickerMultiple([PHPickerResult])
    }

    /// The unified completion block delivering the resulting transaction state payload.
    public typealias Handler = @MainActor (PickerResult) -> Void

    public init() {}

    private var activeDelegate: Delegate?

    // MARK: - Presentation Layer

    /// Instantly bridges and triggers a standard system camera capture viewport using explicit camera specifications.
    ///
    /// - Parameters:
    ///   - viewController: The target view controller anchoring the presentation layer loop.
    ///   - config: The structured specifications mapping properties applied onto the camera device. Defaults to `.default`.
    ///   - handler: The delivery callback receiving the resulting structural ``PickerResult`` state.
    public func presentCamera(
        on viewController: UIViewController,
        with config: CameraConfig = .default,
        completion handler: @escaping Handler
    ) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
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
    /// - Parameters:
    ///   - viewController: The target view controller anchoring presentation loops.
    ///   - config: The structured specifications detailing library selection boundaries. Defaults to `.default`.
    ///   - handler: The callback delivering processed result payloads.
    public func presentLibrary(
        on viewController: UIViewController,
        with config: LibraryConfig = .default,
        completion handler: @escaping Handler
    ) {
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

// Retroactively inject strict compiler-level concurrency approval flags onto the legacy system result metadata class
extension PHPickerResult: @unchecked Sendable {}
