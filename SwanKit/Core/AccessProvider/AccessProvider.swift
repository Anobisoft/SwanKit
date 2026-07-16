//
//  AccessProvider.swift
//  SwanKit
//
//  Created by Stanislav Pletnev on 2026-07-16.
//  Copyright © 2026 Anobisoft. Licensed under the MIT License.
//

#if os(macOS)
import AppKit
#else
import UIKit
#endif

import AVFoundation
import Photos
import Speech

/// A MainActor-isolated capability contract enforcing formal programmatic interfaces to redirect users into systemic privacy configuration sub-panels.
@MainActor
public protocol SettingsOpener {

    /// Explicitly redirects the user layout interaction view directly into the target system settings subsystem panel.
    static func openSettings()
}

#if !os(macOS)
@MainActor
extension SettingsOpener {

    /// Bridges native iOS/tvOS application context handlers to trigger systemic workspace preference panel routes.
    public static func openSettings() {
        UIApplication.openSettings()
    }
}

public extension UIApplication {

    /// Asynchronously opens the application's root settings container deep-link path within the native iOS System Settings hierarchy.
    ///
    /// This method leverages standard `openSettingsURLString` mechanics to safely redirect the user layout context.
    @MainActor
    static func openSettings() {
        let settingsURL = URL(string: self.openSettingsURLString)!
        self.shared.open(settingsURL, options: [:], completionHandler: nil)
    }
}
#endif

/// A unified protocol contract representing an atomic system privacy provider context layout.
public protocol AccessProvider: SettingsOpener {

    /// The associated framework-specific token representing the underlying permission state.
    associatedtype AuthorizationStatus

    /// Asynchronously requests system-level user permission access boundaries on the cooperative thread pool.
    static func requestAccess() async -> AuthorizationStatus
}

/// A unified protocol contract representing a multi-tiered level permission system privacy provider.
public protocol MultiLevelAccessProvider: SettingsOpener {

    /// The associated framework token defining granular scope access tiers (e.g., read-only vs read-write).
    associatedtype AccessLevel

    /// The associated framework token representing the underlying permission state.
    associatedtype AuthorizationStatus

    /// Asynchronously requests a specific tier level of system user permission access boundaries.
    static func requestAccess(level: AccessLevel) async -> AuthorizationStatus
}

/// A declarative facade registry gathering core hardware and media system authorization interfaces under unified types.
public enum Access {

    // MARK: - Photo Library Subsystem

    /// An automated, multi-level privacy manager mediating access permissions for the system Photos framework.
    public enum PhotoLibrary: MultiLevelAccessProvider {
        public typealias AccessLevel = PHAccessLevel
        public typealias AuthorizationStatus = PHAuthorizationStatus

        /// Asynchronously requests permission to interact with the device photo gallery at a specified access depth tier.
        public static func requestAccess(level: AccessLevel) async -> AuthorizationStatus {
            await PHPhotoLibrary.requestAuthorization(for: level)
        }

#if os(macOS)
        /// Navigates the active application context deep-link directly into the system Photo Privacy preferences board.
        @MainActor
        public static func openSettings() {
            NSApplication.openSecurityPrivacySettings(.photos)
        }
#endif
    }

    public enum Capture {
        // MARK: - Audio Microphone Subsystem

        /// An automated, atomic privacy manager mediating hardware access permissions for the device microphone.
        @available(tvOS 17.0, *)
        public enum Audio: AccessProvider {
            public typealias AuthorizationStatus = Bool

            /// Asynchronously requests atomic permission access to capture low-level device hardware microphone streams.
            public static func requestAccess() async -> AuthorizationStatus {
                await AVCaptureDevice.requestAccess(for: .audio)
            }

#if os(macOS)
            /// Navigates the active application context deep-link directly into the system Microphone Privacy preferences board.
            @MainActor
            public static func openSettings() {
                AVCaptureDevice.openSettings(for: .audio)
            }
#endif
        }

        // MARK: - Video Camera Subsystem

        /// An automated, atomic privacy manager mediating hardware access permissions for the device capture camera lenses.
        @available(tvOS 17.0, *)
        public enum Video: AccessProvider {
            public typealias AuthorizationStatus = Bool

            /// Asynchronously requests atomic permission access to capture low-level device hardware video camera frames.
            public static func requestAccess() async -> AuthorizationStatus {
                await AVCaptureDevice.requestAccess(for: .video)
            }

#if os(macOS)
            /// Navigates the active application context deep-link directly into the system Camera Privacy preferences board.
            @MainActor
            public static func openSettings() {
                AVCaptureDevice.openSettings(for: .video)
            }
#endif
        }
    }

    // MARK: - Speech Recognition Subsystem

    /// An automated, atomic privacy manager mediating software access permissions for systemic speech transcription engines.
    @available(tvOS, unavailable)
    public enum SpeechRecognizer: AccessProvider {
        public typealias AuthorizationStatus = SFSpeechRecognizerAuthorizationStatus

        /// Asynchronously evaluates and requests atomic permissions to execute device speech recognition transcription tasks.
        public static func requestAccess() async -> AuthorizationStatus {
            let status = SFSpeechRecognizer.authorizationStatus()
            if status != .notDetermined { return status }

            // Bridge old block-based core framework completion handlers cleanly into modern async boundaries
            return await withCheckedContinuation { continuation in
                SFSpeechRecognizer.requestAuthorization { status in
                    continuation.resume(returning: status)
                }
            }
        }

#if os(macOS)
        /// Navigates the active application context deep-link directly into the system Speech Recognition preferences board.
        @MainActor
        public static func openSettings() {
            NSApplication.openSecurityPrivacySettings(.speechRecognition)
        }
#endif
    }
}

// MARK: - AVFoundation Extensions Utilities

#if os(macOS)
public extension AVCaptureDevice {

    /// Evaluates target media type descriptors to perform intelligent deep-link navigation into appropriate hardware sub-panels.
    /// - Parameter mediaType: The systemic target AVMediaType track context identifier profile (e.g., `.audio`, `.video`).
    @MainActor
    static func openSettings(for mediaType: AVMediaType) {
        switch mediaType {
        case .audio:
            NSApplication.openSecurityPrivacySettings(.microphone)
        case .video:
            NSApplication.openSecurityPrivacySettings(.camera)
        default:
            NSApplication.openSecurityPrivacySettings()
        }
    }
}
#endif
