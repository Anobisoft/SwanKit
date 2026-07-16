//
//  NSApplication+settings.swift
//  SwanKit
//
//  Created by Stanislav Pletnev on 2026-07-16.
//  Copyright © 2026 Anobisoft. Licensed under the MIT License.
//

#if os(macOS)

import AppKit
import Foundation

public extension NSApplication {

    /// Supported system Privacy and Security preference sections available inside macOS System Settings.
    enum PrivacySection: String {
        case locationServices
        case contacts
        case diagnostics
        case calendars
        case reminders
        case photos
        case camera
        case microphone
        case speechRecognition
        case accessibility
        case inputMonitoring
        case screenRecording
        case assistive
        case facebook
        case linkedIn
        case twitter
        case weibo
        case tencentWeibo
    }

    /// Asynchronously opens the macOS System Settings app, optionally deep-linking directly into a specified Privacy sub-section.
    ///
    /// This method automatically transforms the camel-cased case identifier into the exact capitalized string token
    /// required by the native `x-apple.systempreferences:` URL schema structure.
    ///
    /// ### Example Usage:
    /// ```swift
    /// NSApplication.openSecurityPrivacySettings(.microphone)
    /// ```
    ///
    /// - Parameter section: An optional target ``PrivacySection`` panel context descriptor to navigate onto. Defaults to `nil`.
    @MainActor
    static func openSecurityPrivacySettings(_ section: PrivacySection? = nil) {
        var urlString = "x-apple.systempreferences:com.apple.preference.security?Privacy"
        if var section = section?.rawValue {
            let start = section.startIndex
            section.replaceSubrange(start...start, with: section[start].uppercased())
            urlString.append("_" + section)
        }

        guard let settingsURL = URL(string: urlString) else { return }
        NSWorkspace.shared.open(settingsURL)
    }
}

#endif
