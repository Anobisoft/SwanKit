//
//  UIColor+RGB.swift
//  SwanKit
//
//  Created by Stanislav Pletnev on 2019-11-11.
//  Copyright © 2019 Anobisoft. All rights reserved.
//

import UIKit

public extension UIColor {
    
    convenience init(red: UInt8, green: UInt8, blue: UInt8, alpha: Float = 1) {
        self.init(red: CGFloat(red) / 255,
                  green: CGFloat(green) / 255,
                  blue: CGFloat(blue) / 255,
                  alpha: CGFloat(alpha))
    }
    
    convenience init(rgb: Int, alpha: Float = 1) {
        self.init(
            red: UInt8(rgb >> 16 & 0xFF),
            green: UInt8(rgb >> 8 & 0xFF),
            blue: UInt8(rgb & 0xFF),
            alpha: alpha
        )
    }
}
