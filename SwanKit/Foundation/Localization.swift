//
//  Localization.swift
//  SwanKit
//
//  Created by Stanislav Pletnev on 2019-11-12.
//  Copyright © 2019 Anobisoft. All rights reserved.
//

import Foundation

public extension String {
    
    func localized(_ bundle: Bundle = .main) -> String {
        bundle.localize(self)
    }
    
    var localized: String {
        return localized()
    }
}

extension Bundle {
    
    func localize(_ key: String, table: String? = nil) -> String {
        self.localizedString(forKey: key, value: nil, table: nil)
    }
}

