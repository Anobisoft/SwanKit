//
//  UIColor+RGB.swift
//  SwanKit
//
//  Created by Stanislav Pletnev on 2026-07-16.
//  Copyright © 2026 Anobisoft. Licensed under the MIT License.
//

import UIKit

public extension UIColor {

    /// Initializes a color object using standard integrated 8-bit integer channel components (0-255).
    ///
    /// This initializer eliminates the need to manually compute floating-point divisions (`channel / 255.0`) at the call site.
    ///
    /// ### Example Usage:
    /// ```swift
    /// let customTeal = UIColor(red: 0, green: 255, blue: 221, alpha: 1.0)
    /// ```
    ///
    /// - Parameters:
    ///   - red: The red component value of the color object (0 to 255).
    ///   - green: The green component value of the color object (0 to 255).
    ///   - blue: The blue component value of the color object (0 to 255).
    ///   - alpha: The opacity value of the color object, specified as a value from 0.0 to 1.0. Defaults to 1.0.
    convenience init(
        red: UInt8,
        green: UInt8,
        blue: UInt8,
        alpha: Float = 1
    ) {
        self.init(
            red: CGFloat(red) / 255,
            green: CGFloat(green) / 255,
            blue: CGFloat(blue) / 255,
            alpha: CGFloat(alpha)
        )
    }

    /// Initializes a color object using a single integer hex bitmask representation (e.g., `0x00FFDD`).
    ///
    /// This method automatically extracts individual 8-bit red, green, and blue hardware channels
    /// using high-performance bitwise right-shift (`>>`) and logical AND (`&`) masking operators.
    ///
    /// ### Example Usage:
    /// ```swift
    /// let brandTeal = UIColor(rgb: 0x00FFDD, alpha: 1.0)
    /// ```
    ///
    /// - Parameters:
    ///   - rgb: The single 24-bit hexadecimal integer value encoding RGB values sequentially.
    ///   - alpha: The opacity value of the color object, specified as a value from 0.0 to 1.0. Defaults to 1.0.
    convenience init(
        rgb: Int,
        alpha: Float = 1
    ) {
        self.init(
            red: UInt8(
                rgb >> 16 & 0xFF
            ),
            green: UInt8(
                rgb >> 8 & 0xFF
            ),
            blue: UInt8(
                rgb & 0xFF
            ),
            alpha: alpha
        )
    }
}
