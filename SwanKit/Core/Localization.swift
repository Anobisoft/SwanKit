//
//  Localization.swift
//  SwanKit
//
//  Created by Stanislav Pletnev on 2026-07-16.
//  Copyright © 2026 Anobisoft. Licensed under the MIT License.
//

import Foundation

public extension Bundle {
    /// A runtime proxy instance that dynamically detects the bundle of the calling framework on the fly.
    ///
    /// Use this instance when you want a shared utility or a subframework to load strings
    /// from the specific module that initiated the localization call, rather than forcing a hardcoded bundle.
    ///
    /// ```swift
    /// let text = "profile_title".localized(.dynamic)
    /// ```
    static var dynamic: Bundle {
        DynamicBundle.shared
    }
}

public extension String {
    /// Localizes the string using the specified bundle, table, and default value.
    ///
    /// - Parameters:
    ///   - bundle: The target bundle containing the strings file. Defaults to `.main`.
    ///   - value: The value to return if the key is not found in the table. Defaults to `nil`.
    ///   - table: The receiver's string table to search. Defaults to `nil` (loads from `Localizable.strings`).
    /// - Returns: A localized version of the string, or the key itself if no translation is found.
    @inlinable
    func localized(_ bundle: Bundle = .main, value: String? = nil, table: String? = nil) -> String {
        bundle.localized(self, value: value, table: table)
    }

    /// A fast computed shorthand property for standard localization via the main application bundle.
    ///
    /// ```swift
    /// let title = "welcome_message".localized
    /// ```
    @inlinable
    var localized: String {
        localized()
    }

    /// A computed shorthand property that leverages context-aware dynamic bundle resolution.
    ///
    /// This property automatically looks up the localization assets of whichever custom framework
    /// executes the statement, falling back safely to `.main` if the context cannot be verified.
    ///
    /// ```swift
    /// let frameworkText = "feature_header".localizedDynamic
    /// ```
    var localizedDynamic: String {
        localized(.dynamic)
    }
}

// MARK: - Internal Dynamic Proxy Core

/// A private proxy class that overrides the standard Cocoa localization routing.
private final class DynamicBundle: Bundle, @unchecked Sendable {
    static let shared = DynamicBundle()

    override func localizedString(forKey key: String, value: String?, table: String?) -> String {
        // Inspects the backtrace return addresses to identify the calling module framework
        let symbols = Thread.callStackReturnAddresses
        if symbols.count > 2 {
            let callerAddress = UnsafeRawPointer(bitPattern: symbols[2].intValue)
            if let address = callerAddress, let callerBundle = Bundle(forAddress: address) {
                return callerBundle.localizedString(forKey: key, value: value, table: table)
            }
        }

        // Fallback to the primary main application container if stack inspection boundaries fail
        return Bundle.main.localizedString(forKey: key, value: value, table: table)
    }
}

// MARK: - Backtrace Memory Inspection Bridge

private extension Bundle {
    /// Resolves and initialises a physical `Bundle` container mapped to a specific Dynamic Shared Object (DSO) memory handle.
    convenience init?(forAddress address: UnsafeRawPointer) {
        var info = Dl_info()
        guard dladdr(address, &info) != 0, let path = info.dli_fname else { return nil }
        let url = URL(fileURLWithPath: String(cString: path))

        var currentURL = url
        while currentURL.pathComponents.count > 1 {
            let ext = currentURL.pathExtension
            if ext == "framework" || ext == "bundle" || ext == "app" {
                self.init(url: currentURL)
                return
            }
            currentURL = currentURL.deletingLastPathComponent()
        }
        return nil
    }
}

extension Bundle {
    @inlinable
    func localized(_ key: String, value: String? = nil, table: String? = nil) -> String {
        localizedString(forKey: key, value: value, table: table)
    }
}
