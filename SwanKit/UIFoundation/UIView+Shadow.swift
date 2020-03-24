//
//  Shadow.swift
//  SwanKit
//
//  Created by Stanislav Pletnev on 2019-11-11.
//  Copyright © 2019 Anobisoft. All rights reserved.
//

import UIKit

public extension UIView {
    
    struct Shadow {
        var radius  : Float
        var color   : UIColor
        var opacity : Float
        var offset  : CGSize
        
        public init(radius  : Float   = 10,
                    color   : UIColor = .black,
                    opacity : Float   = 1,
                    offset  : CGSize  = .zero) {
            
            self.radius = radius
            self.color = color
            self.opacity = opacity
            self.offset = offset
        }
    }
    
    @discardableResult
    func shadow(radius: Float = 10, color: UIColor = .black, opacity: Float = 1, offset: CGSize = .zero) -> Self {
        self.layer.shadowRadius = CGFloat(radius)
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offset
        self.layer.masksToBounds = false
        return self
    }
    
    @discardableResult
    func shadow(_ shadow: Shadow) -> Self {
        self.shadow(radius: shadow.radius, color: shadow.color, opacity: shadow.opacity, offset: shadow.offset)
    }
}
