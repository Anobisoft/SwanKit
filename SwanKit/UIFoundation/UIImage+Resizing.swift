//
//  UIImage+resizing.swift
//  SwanKit
//
//  Created by Stanislav Pletnev on 2019-12-02.
//  Copyright © 2019 Anobisoft. All rights reserved.
//

import UIKit

public extension UIImage {
    func resized(_ newSize: CGSize, scale: CGFloat = 1.0) -> UIImage {

        guard self.size != newSize else { return self }

        UIGraphicsBeginImageContextWithOptions(newSize, false, scale);
        self.draw(in: .init(origin: .zero, size: newSize))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return newImage
    }

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
