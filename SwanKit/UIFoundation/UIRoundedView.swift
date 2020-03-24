//
//  UIRoundedView.swift
//  SwanKit
//
//  Created by Stanislav Pletnev on 2019-11-06.
//  Copyright © 2019 Anobisoft. All rights reserved.
//

import UIKit

public class UIRoundedView: UIView {
    
    public var corners: UIRectCorner = []
    
    override public var cornerRadius: CGFloat {
        get {
            _cornerRadius
        }
        set {
            _cornerRadius = newValue
        }
    }

    override public func layoutSublayers(of layer: CALayer) {
        shapeLayer.path = roundPath
        layer.mask = shapeLayer
        super.layoutSublayers(of: layer)
    }
    
    private var _cornerRadius: CGFloat = 0
    private var shapeLayer: CAShapeLayer = CAShapeLayer()
    
    private var roundPath: CGPath {
        UIBezierPath(roundedRect: bounds,
                     byRoundingCorners: corners,
                     cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)).cgPath
    }
}
