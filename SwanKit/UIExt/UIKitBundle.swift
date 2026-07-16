//
//  UIKitBundle.swift
//  SwanKit
//
//  Created by Stanislav Pletnev on 2026-07-16.
//  Copyright © 2026 Anobisoft. Licensed under the MIT License.
//

import UIKit

public extension Bundle {

    /// Dynamically resolves and retrieves the main system `Bundle` container instance associated with the native `UIKit` framework.
    ///
    /// This utility uses class-based reflection metadata lookup sequences targeting `UIApplication` to locate the native
    /// system framework resources. It serves as the core subsystem anchor required for automated system-level
    /// localization lookups (e.g., retrieving official system translations for buttons like "Cancel" or "Camera").
    ///
    /// ### Example Usage:
    /// ```swift
    /// let uikitBundle = Bundle.UIKit
    /// let localizedCancel = uikitBundle.localizedString(forKey: "Cancel", value: nil, table: nil)
    /// ```
    static var UIKit: Bundle {
        Self(for: UIApplication.self)
    }
}
