
#if os(macOS)

import Foundation

public extension NSApplication {
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

    static func openSecurityPrivacySettings(_ section: PrivacySection? = nil) {
        var urlString = "x-apple.systempreferences:com.apple.preference.security?Privacy"
        if var section = section?.rawValue {
            let start = section.startIndex
            section.replaceSubrange(start...start, with: section[start].uppercased())
            urlString.append("_" + section)
        }
        let settingsURL = URL(string: urlString)!
        NSWorkspace.shared.open(settingsURL)
    }
}

#else

import UIKit

public extension UIApplication {
    static func openSettings() {
        let settingsURL = URL(string: self.openSettingsURLString)!
        self.shared.open(settingsURL, options: [:], completionHandler: nil)
    }
}

#endif
