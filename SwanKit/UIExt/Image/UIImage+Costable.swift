//
//  UIImage+Costable.swift
//  SwanKit
//
//  Created by Stanislav Pletnev on 2026-07-17.
//  Copyright © 2026 Anobisoft. Licensed under the MIT License.
//

import UIKit
import SwanKitFoundation

extension UIImage: Costable {

    /// Returns the exact uncompressed memory footprint of the underlying image raster buffer in bytes.
    ///
    /// This computation runs in O(1) time complexity as it reads pre-calculated metadata from the structural
    /// `CGImage` layers, avoiding heavy runtime binary serialization overhead (like `jpegData` conversions).
    public var cost: Int {
        guard let cgImage = self.cgImage else {
            // Фолбек для картинок на базе CIImage (например, сгенерированных фильтрами CoreImage)
            return Int(size.width * size.height * 4)
        }
        return cgImage.bytesPerRow * cgImage.height
    }
}
