
#if !os(macOS)
import UIKit
#endif
import Photos
#if !os(tvOS)
import Speech
#endif

public protocol AccessProvider {
    associatedtype AuthorizationStatus
    static func requestAccess() async -> AuthorizationStatus
    static func openSettings()
}

public protocol MultiLevelAccessProvider {
    associatedtype AccessLevel
    associatedtype AuthorizationStatus
    static func requestAccess(level: AccessLevel) async -> AuthorizationStatus
    static func openSettings()
}

public struct Access {
    public enum PhotoLibrary: MultiLevelAccessProvider {
        public typealias AccessLevel = PHAccessLevel
        public typealias AuthorizationStatus = PHAuthorizationStatus

        public static func requestAccess(level: AccessLevel) async -> AuthorizationStatus {
            await PHPhotoLibrary.requestAuthorization(for: level)
        }

        public static func openSettings() {
            Task { @MainActor in
#if os(macOS)
                NSApplication.openSecurityPrivacySettings(.photos)
#else
                UIApplication.openSettings()
#endif
            }
        }
    }

    @available(tvOS, unavailable)
    public enum Audio: AccessProvider {
        public typealias AuthorizationStatus = Bool

        public static func requestAccess() async -> AuthorizationStatus {
            await AVCaptureDevice.requestAccess(for: .audio)
        }

        public static func openSettings() {
            AVCaptureDevice.openSettings(for: .audio)
        }
    }

    @available(tvOS, unavailable)
    public enum Video: AccessProvider {
        public typealias AuthorizationStatus = Bool

        public static func requestAccess() async -> AuthorizationStatus {
            await AVCaptureDevice.requestAccess(for: .video)
        }

        public static func openSettings() {
            AVCaptureDevice.openSettings(for: .video)
        }
    }

    @available(tvOS, unavailable)
    enum SpeechRecognizer: AccessProvider {
        public typealias AuthorizationStatus = SFSpeechRecognizerAuthorizationStatus

        public static func requestAccess() async -> AuthorizationStatus {
            let status = SFSpeechRecognizer.authorizationStatus()
            if status != .notDetermined { return status }
            return await withCheckedContinuation { continuation in
                SFSpeechRecognizer.requestAuthorization { status in
                    continuation.resume(returning: status)
                }
            }
        }

        public static func openSettings() {
            Task { @MainActor in
#if os(macOS)
                NSApplication.openSecurityPrivacySettings(.speechRecognition)
#else
                UIApplication.openSettings()
#endif
            }
        }
    }
}

@available(tvOS, unavailable)
public extension AVCaptureDevice {
    static func openSettings(for mediaType: AVMediaType) {
        Task { @MainActor in
#if os(macOS)
            switch type {
            case .audio:
                NSApplication.openSecurityPrivacySettings(.microphone)
            case .video:
                NSApplication.openSecurityPrivacySettings(.camera)
            default:
                NSApplication.openSecurityPrivacySettings()
            }
#else
            UIApplication.openSettings()
#endif
        }
    }
}
