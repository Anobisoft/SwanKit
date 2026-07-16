//
//  UIWindowScene+active.swift
//  SwanKit
//
//  Created by Stanislav Pletnev on 2026-07-17.
//  Copyright © 2026 Anobisoft. Licensed under the MIT License.
//

import UIKit

@MainActor
public extension UIWindowScene {

    /// Dynamically resolves and retrieves the currently active, foreground-isolated `UIWindowScene` instance.
    ///
    /// This utility safely parses the application's connected scenes pool to identify the exact window scene
    /// that is actively receiving user interactions in the foreground, mitigating legacy `UIApplication.keyWindow` deprecation issues.
    ///
    /// ### Example Usage:
    /// ```swift
    /// if let activeScene = UIWindowScene.active {
    ///     // Perform scene-specific layout queries
    /// }
    /// ```
    static var active: UIWindowScene? {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first { $0.activationState == .foregroundActive }
    }

    /// Extracts the primary, active key window reference bound to the receiver window scene layout tree.
    ///
    /// - Returns: The designated `UIWindow` currently flagged as the key window, or `nil` if no window has accepted focus.
    var keyWindow: UIWindow? {
        windows.first { $0.isKeyWindow }
    }
}
