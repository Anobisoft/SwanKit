//
//  AccessProvider.swift
//  SwanKit
//
//  Created by Stanislav Pletnev on 2019-11-06.
//  Copyright © 2019 Anobisoft. All rights reserved.
//

import Photos

public protocol AccessProvider {
    static func accessRequest(completion: @escaping Access.Completion)
}

public struct Access {
    public typealias Completion = (_ granted: Bool) -> Void

    public static let photoLibrary: AccessProvider.Type = PHPhotoLibrary.self

#if !os(tvOS)
    @available(tvOS, unavailable)
    public static let video: AccessProvider.Type = Video.self
    @available(tvOS, unavailable)
    public static let audio: AccessProvider.Type = Audio.self

    public static let speechRecognition: AccessProvider.Type = SFSpeechRecognizer.self

    @available(tvOS, unavailable)
    private struct Video: AccessProvider {
        static func accessRequest(completion: @escaping Access.Completion) {
            AVCaptureDevice.accessRequest(.video, completion: completion)
        }
    }

    @available(tvOS, unavailable)
    private struct Audio: AccessProvider {
        static func accessRequest(completion: @escaping Access.Completion) {
            AVCaptureDevice.accessRequest(.audio, completion: completion)
        }
    }
#endif
}

#if !os(tvOS)

import Speech

@available(tvOS, unavailable)
extension SFSpeechRecognizer: AccessProvider {
    public static func accessRequest(completion: @escaping Access.Completion) {
        if self.authorizationStatus() == .authorized {
            completion(true)
            return
        }
        self.requestAuthorization { status in
            DispatchQueue.main.async {
                let granted = status == .authorized
                completion(granted)
                if !granted {
#if os(macOS)
                    NSApplication.openSecurityPrivacySettings(.speechRecognition)
#else
                    UIApplication.openSettings()
#endif
                }
            }
        }
    }
}

@available(tvOS, unavailable)
private extension AVCaptureDevice {
    static func accessRequest(_ type: AVMediaType, completion: @escaping Access.Completion) {
        if AVCaptureDevice.authorizationStatus(for: type) == .authorized {
            completion(true)
            return
        }
        AVCaptureDevice.requestAccess(for: type) { granted in
            DispatchQueue.main.async {
                completion(granted)
                if !granted {
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
    }
}

#endif

extension PHPhotoLibrary: AccessProvider {
    public static func accessRequest(completion: @escaping Access.Completion) {
        if self.authorizationStatus() == .authorized {
            completion(true)
            return
        }
        self.requestAuthorization { status in
            DispatchQueue.main.async {
                let granted = status == .authorized
                completion(granted)
                if !granted {
#if os(macOS)
                    NSApplication.openSecurityPrivacySettings(.photos)
#else
                    UIApplication.openSettings()
#endif
                }
            }
        }
    }
}
