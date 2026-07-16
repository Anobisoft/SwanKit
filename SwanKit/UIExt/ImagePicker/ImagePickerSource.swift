//
//  ImagePickerSource.swift
//  SwanKit
//
//  Created by Stanislav Pletnev on 2026-07-16.
//  Copyright © 2026 Anobisoft. Licensed under the MIT License.
//

import UIKit
import SwanKitFoundation

@MainActor
public extension ImagePicker {

    /// Systemic media source types supported natively by the framework backend architecture.
    enum SourceType: Int, Sendable {
        case camera
        case photoLibrary
        @MainActor
        var isAvailable: Bool {
            self == .photoLibrary || UIImagePickerController.isSourceTypeAvailable(.camera)
        }
    }

    /// A thread-safe option set representing a bitmask array of available media source configurations.
    struct SourceOptions: OptionSet, Sendable {
        public let rawValue: Int

        public init(rawValue: Int) {
            self.rawValue = rawValue
        }

        /// Grants exposure and availability access strictly for active hardware camera lenses.
        public static let camera       = SourceOptions(rawValue: 1 << SourceType.camera.rawValue)

        /// Grants exposure and selection constraints directly for photo catalog library bundles.
        public static let photoLibrary = SourceOptions(rawValue: 1 << SourceType.photoLibrary.rawValue)

        /// Standard balanced configuration presenting both hardware camera and systemic media gallery libraries simultaneously.
        public static let standard: SourceOptions = [.camera, .photoLibrary]

        /// Evaluates whether a specific explicit ``SourceType`` rule token is currently contained within the bitmask layout.
        public func includes(_ sourceType: SourceType) -> Bool {
            contains(Self(rawValue: 1 << sourceType.rawValue))
        }
    }

    /// A localized string registry map translating structural source types into official localized system button labels.
    static let sourceTypesLocalizationMap: [SourceType: String] = [
        .camera: "Camera".localized(.UIKit),
        .photoLibrary: "Photo Library".localized(.UIKit)
    ]

    /// Standard pre-localized cancellation text asset pulled recursively from the core system application container.
    static let cancelButtonTitle = "Cancel".localized(.UIKit)
}
