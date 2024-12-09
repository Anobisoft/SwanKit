//
//  UIImage+Pixel.swift
//  SwanKit
//
//  Created by Stanislav Pletnev on 2019-23-11.
//  Copyright © 2019 Anobisoft. All rights reserved.
//

import UIKit

public extension UIImage {
    static let pixelCache = Cache<UIColor, UIImage>()

    static func pixel(_ color: UIColor) -> UIImage {
        if let cached = pixelCache[color] {
            return cached
        }
        let size = CGSize(width: 1.0, height: 1.0)
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(size, true, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()!

        context.setFillColor(color.cgColor)
        context.fill(rect)

        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        pixelCache[color] = image
        return image
    }
}

