//
//  UIKitBundle.swift
//  SwanKit
//
//  Created by Stanislav Pletnev on 2019-12-03.
//  Copyright © 2019 Anobisoft. All rights reserved.
//

import UIKit

public extension Bundle {
    
    static var UIKit: Bundle {
        Self(for: UIApplication.self)
    }
    
    var localizableStrings: [String: String]? {
        guard let fileURL = url(forResource: "Localizable", withExtension: "strings") else {
            return nil
        }
        do {
            let data = try Data(contentsOf: fileURL)
            let plist = try PropertyListSerialization.propertyList(from: data, format: .none)
            return plist as? [String: String]
        } catch {
            print(error)
        }
        return nil
    }
}
