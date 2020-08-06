//
//  Keychain.Query.swift
//  SwanKit
//
//  Created by Stanislav Pletnev on 2020-08-04.
//  Copyright © 2020 Anobisoft. All rights reserved.
//

import Foundation

extension Keychain {
    typealias QueryData = Dictionary<String, AnyObject>
}

extension Dictionary {
    var CF: CFDictionary {
        self as CFDictionary
    }
}

extension Keychain.QueryData {
    
    mutating func setSecClass(_ secClass: Keychain.SecClass) {
        self[kSecClass] = secClass.rawValue
    }
    
    subscript(key: CFString) -> AnyObject? {
        get { self[key as String] }
        set { self[key as String] = newValue }
    }
    subscript(key: CFString) -> String? {
        get { self[key as String] as? String }
        set { self[key as String] = newValue as AnyObject }
    }
    subscript(key: CFString) -> Data? {
        get { self[key as String] as? Data }
        set { self[key as String] = newValue as AnyObject }
    }
    subscript(key: CFString) -> Bool {
        get { CFBooleanCast(self[key as String]) }
        set { self[key as String] = (newValue ? kCFBooleanTrue : kCFBooleanFalse) as AnyObject }
    }
    
    func CFBooleanCast(_ optional: AnyObject?) -> Bool {
        guard let value = optional else {
            return false
        }
        guard CFGetTypeID(value) == CFBooleanGetTypeID() else {
            return false
        }
        return CFBooleanGetValue(.some(value as! CFBoolean))
    }
}
