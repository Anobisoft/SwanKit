//
//  Alert.swift
//  SwanKit
//
//  Created by Stanislav Pletnev on 2026-07-16.
//  Copyright © 2026 Anobisoft. Licensed under the MIT License.
//

import UIKit

@MainActor
public extension UIAlertAction {

    /// A pre-configured, systemic cancellation alert action initialized with the official localized "Cancel" title matching the device locale.
    static let cancel: UIAlertAction = {
        .init(title: "Cancel".localized(.UIKit), style: .cancel)
    }()

    /// A MainActor-isolated callback closure definition executed when a targeted alert action is selected.
    typealias Handler = @MainActor (UIAlertAction) -> Void
}

@MainActor
public extension UIAlertController {

    /// Concurrently appends a standardized cancellation action onto the receiver controller layout.
    ///
    /// - Parameter handler: An optional ``UIAlertAction/Handler`` executed upon confirmation. Defaults to `nil`.
    func addCancel(_ handler: UIAlertAction.Handler? = nil) {
        addAction(.init(title: "Cancel".localized(.UIKit), style: .cancel, handler: handler))
    }

    /// Convenience wrapper to synthesize and instantly append a new custom action title row onto the receiver alert controller layout.
    ///
    /// - Parameters:
    ///   - title: The visual text label shown on the button action row.
    ///   - style: The technical styling metrics applied onto the row (e.g., `.default`, `.destructive`).
    ///   - handler: An optional execution callback closure context. Defaults to `nil`.
    func addAction(title: String, style: UIAlertAction.Style, handler: UIAlertAction.Handler? = nil) {
        addAction(.init(title: title, style: style, handler: handler))
    }

    /// Initializes a standardized alert controller instance using crisp declarative default styling metrics.
    ///
    /// - Parameters:
    ///   - title: An optional primary header title string. Defaults to `nil`.
    ///   - message: An optional supplemental description message text body. Defaults to `nil`.
    ///   - style: The structural interface presentation layout mode. Defaults to `.alert`.
    convenience init(title: String? = nil, message: String? = nil, style: UIAlertController.Style = .alert) {
        self.init(title: title, message: message, preferredStyle: style)
    }
}
