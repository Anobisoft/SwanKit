//
//  UIImage+Resizing.swift
//  SwanKit
//
//  Created by Stanislav Pletnev on 2026-07-16.
//  Copyright © 2026 Anobisoft. Licensed under the MIT License.
//

import UIKit

public extension UIImage {

    /// Resizes the receiver image to a specified canvas size using explicit scale metrics.
    ///
    /// This method leverages the modern thread-safe `UIGraphicsImageRenderer` layout engine,
    /// making it safe to execute outside the main execution thread context (e.g., inside background processing workers).
    ///
    /// - Parameters:
    ///   - newSize: The target geometric `CGSize` configuration layout profile.
    ///   - scale: The scale factor applied onto the rendered canvas. Defaults to `1.0`.
    /// - Returns: A newly allocated, resized `UIImage` instance block, or the receiver self if sizes match exactly.
    func resized(_ newSize: CGSize, scale: CGFloat = 1.0) -> UIImage {
        guard self.size != newSize else { return self }

        let format = UIGraphicsImageRendererFormat()
        format.scale = scale
        format.opaque = false

        let renderer = UIGraphicsImageRenderer(size: newSize, format: format)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }

    /// Dynamically scales the receiver image layout to fit or fill a target bounding box using standard content mode behavior rules.
    ///
    /// Enforces exact geometric calculations mimicking systemic `UIView.ContentMode` layouts natively in memory.
    ///
    /// ### Example Usage:
    /// ```swift
    /// let avatarPreview = largeImage.scaled(to: CGSize(width: 200, height: 200), mode: .scaleAspectFill)
    /// ```
    ///
    /// - Parameters:
    ///   - target: The maximum bounding box `CGSize` dimensions context.
    ///   - mode: The content mode formatting strategy (supports `.scaleAspectFit`, `.scaleAspectFill`, and `.scaleToFill`). Defaults to `.scaleAspectFit`.
    /// - Returns: A beautifully proportioned, scaled `UIImage` instance.
    func scaled(to target: CGSize, mode: UIView.ContentMode = .scaleAspectFit) -> UIImage {
        var height = target.height
        var width  = height * size.width / size.height

        var recalc = false
        switch mode {
        case .scaleAspectFit:
            recalc = width > target.width
        case .scaleAspectFill:
            recalc = width < target.width
        case .scaleToFill:
            width = target.width
        default:
            break
        }

        if recalc {
            width  = target.width
            height = width * size.height / size.width
        }

        return resized(CGSize(width: width, height: height), scale: self.scale)
    }
}
