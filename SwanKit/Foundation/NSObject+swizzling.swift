//
//  NSObject+swizzling.swift
//  SwanKit
//
//  Created by Stanislav Pletnev on 2019-23-11.
//  Copyright © 2019 Anobisoft. All rights reserved.
//

import Foundation

public extension NSObject {    
    static func swizzle(_ origin: Selector, _ swizzl: Selector) {
        let origin_method = class_getInstanceMethod(self, origin)
        let swizzl_method = class_getInstanceMethod(self, swizzl)
        method_exchangeImplementations(origin_method!, swizzl_method!)
    }
}
