//
//  UIImage+background.swift
//  SwanKit
//
//  Created by Stanislav Pletnev on 2026-07-19.
//  Copyright © 2026 Anobisoft. Licensed under the MIT License.
//

import UIKit
import SwanKitFoundation

public extension UIImage {

    /// Renders the current vector or raster image centered over a solid, non-transparent background canvas rectangle.
    ///
    /// This extension leverages `UIGraphicsImageRenderer` to perform high-performance, thread-safe pixel
    /// baking natively on the GPU layer. It avoids transparent alpha channel bleeding by enforcing strict opaque formats.
    ///
    /// ### Architectural Note:
    /// It elegantly utilizes SwanKit's native ``Emptyable`` engine and the custom `~?` operator to determine
    /// layout geometries. If the target `canvasSize` evaluates to an empty state (`.zero`), it automatically
    /// falls back to the host image's native physical size boundaries.
    ///
    /// - Parameters:
    ///   - color: The uniform solid `UIColor` used to fill the underlying canvas background rectangle.
    ///   - canvasSize: The targeted framing dimension box. Defaults to `.zero` (which auto-triggers host size fallbacks).
    /// - Returns: A brand new, fully opaque `UIImage` composite slice.
    func withSolidBackground(color: UIColor, canvasSize: CGSize = .zero) -> UIImage {
        let format = UIGraphicsImageRendererFormat.default()
        format.opaque = true
        format.scale = scale
        let canvasSize = canvasSize ~? size

        let renderer = UIGraphicsImageRenderer(size: canvasSize, format: format)
        return renderer.image { context in
            // 1. Render the non-transparent flat solid background color layer
            color.setFill()
            context.fill(CGRect(origin: .zero, size: canvasSize))

            // 2. Mathematically compute symmetrical offset points to position the source vector dead-center
            let originX = (canvasSize.width - size.width) / 2
            let originY = (canvasSize.height - size.height) / 2

            // 3. Bake the final composite image graphics layer pass
            draw(at: CGPoint(x: originX, y: originY))
        }
    }
}
