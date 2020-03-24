//
//  String+CaseConverting.swift
//  SwanKit
//
//  Created by Stanislav Pletnev on 2019-12-02.
//  Copyright © 2019 Anobisoft. All rights reserved.
//

import Foundation

public extension String {
    
    var snake_case_to_CamelCase: String {
        self.components(separatedBy: "_")
            .map { $0.capitalized }
            .joined()
    }
    
    var snake_case_to_lamaCase: String {
        var result = snake_case_to_CamelCase
        let start = startIndex
        result.replaceSubrange(start...start, with: result[start].lowercased())
        return result
    }

    var lamaCaseTo_snake_Eating_Train: String {
        replacingOccurrences(of: "([A-Z,\\d]+)", with: "_$1",
                             options: .regularExpression, range: nil)
    }

    var lamaCaseTo_SCREAMING_SNAKE: String {
        lamaCaseTo_snake_Eating_Train.uppercased()
    }
}
