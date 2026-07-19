//
//  UIImage+Pixel.swift
//  SwanKit
//
//  Created by Stanislav Pletnev on 2026-07-16.
//  Copyright © 2026 Anobisoft. Licensed under the MIT License.
//

import UIKit
import SwanKitFoundation

public extension UIImage {

    /// A dedicated structural namespace separating dynamic single-pixel rendering assets from general image instances.
    enum Pixel {}
}

@MainActor
public extension UIImage.Pixel {

    private static let cache = Cache<UIColor, UIImage>()

    /// Configures memory thresholds and retention boundaries for the internal dynamic pixel cache engine.
    ///
    /// Since 1x1 pixels occupy a negligible RAM footprint (~4 bytes per node), custom allocation boundaries
    /// should be specified explicitly based on target application runtime requirements.
    ///
    /// - Parameters:
    ///   - countLimit: The maximum number of distinct colored pixels to secure inside memory.
    ///   - totalCostLimit: The maximum integrated byte cost weight allowed before eviction.
    static func configureCache(countLimit: Int? = nil, totalCostLimit: Int? = nil) {
        cache.countLimit = countLimit~!
        cache.totalCostLimit = totalCostLimit~!
    }

    /// Generates a solid 1x1 pixel image filled with the specified color dynamically in memory.
    ///
    /// This method leverages the modern thread-safe `UIGraphicsImageRenderer` layout engine,
    /// caching generated pixels seamlessly to optimize global interface rendering passes.
    ///
    /// ### Example Usage:
    /// ```swift
    /// let redLine = UIImage.Pixel.makeImage(.red)
    /// ```
    ///
    /// - Parameter color: The target `UIColor` instance used to fill the pixel canvas.
    /// - Returns: A cached or newly rendered 1x1 `UIImage` object configuration.
    static func makeImage(_ color: UIColor) -> UIImage {
        if let cached = cache[color] {
            return cached
        }

        let size = CGSize(width: 1.0, height: 1.0)
        let rect = CGRect(origin: .zero, size: size)

        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { rendererContext in
            let context = rendererContext.cgContext
            context.setFillColor(color.cgColor)
            context.fill(rect)
        }

        cache[color] = image
        return image
    }
}
