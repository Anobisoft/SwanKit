//
//  ImagePicker+Config.swift
//  SwanKit
//
//  Created by Stanislav Pletnev on 2026-07-19.
//  Copyright © 2026 Anobisoft. Licensed under the MIT License.
//

import UIKit

public extension ImagePicker {

    /// A configuration blueprint grouping explicit operational metrics required for hardware camera captures.
    ///
    /// Use this structure to dictate the hardware capabilities, flash modes, and editing constraints
    /// applied dynamically onto the device camera lenses when spinning up recording sessions.
    struct CameraConfig: Sendable {

        /// A Boolean value determining whether the system interface allows the user to crop or scale the captured frame cut.
        public var allowsEditing: Bool

        /// The specific target physical camera lens device utilized upon viewport instantiation (e.g., front-facing vs rear lens).
        public var cameraDevice: UIImagePickerController.CameraDevice

        /// The active flash mode applied onto hardware capture sequences (e.g., automatic orchestration, forced on, or disabled).
        public var cameraFlashMode: UIImagePickerController.CameraFlashMode

        /// Instantiates a specialized hardware camera capture tracking profile blueprint.
        ///
        /// - Parameters:
        ///   - allowsEditing: Dictates custom geometric frame cropping boundaries. Defaults to `false`.
        ///   - cameraDevice: Sets the target physical lens alignment direction. Defaults to `.rear`.
        ///   - cameraFlashMode: Defines the physical flash activation operational metrics rules. Defaults to `.auto`.
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
    ///
    /// This structure defines constraints such as batch limits required to orchestrate photo library selection sheets uniformly.
    struct LibraryConfig: Sendable {

        /// The maximum number of distinct assets a user can select inside the library catalog gallery picker.
        ///
        /// Configuration Rules Matrix:
        /// - Set to `1` to enforce strict atomic singular selection choices.
        /// - Set to `0` to enable unlimited bidirectional multi-selection framework constraints.
        public var selectionLimit: Int

        /// Instantiates a specialized gallery catalog preference blueprint.
        ///
        /// - Parameter selectionLimit: The maximum allowed assets selection range cap parameter. Defaults to `1`.
        public init(selectionLimit: Int = 1) {
            self.selectionLimit = selectionLimit
        }

        /// Standard default configuration for gallery picker interfaces: single item selection framework constraint.
        public static let `default` = LibraryConfig()
    }
}
