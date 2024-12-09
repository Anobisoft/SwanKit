//
//  String+CaseConverting.swift
//  SwanKit
//
//  Created by Stanislav Pletnev on 2019-12-02.
//  Copyright © 2019 Anobisoft. All rights reserved.
//

import Foundation

public extension String {
    func transcodeFirst(_ transcode: (Character) -> String) -> String {
        guard let f = first else { return "" }
        return transcode(f) + dropFirst()
    }

    func upperFirst() -> String {
        transcodeFirst { $0.uppercased() }
    }

    var snakeComponents: [String] {
        components(separatedBy: "_")
    }

    /// snake_case => PascalCase
    var pascalCasedSnake: String {
        snakeComponents.map { $0.capitalized }.joined()
    }

    /// snake_case => camelCase
    var camelCasedSnake: String {
        pascalCasedSnake.transcodeFirst { $0.lowercased() }
    }

    /// camelCase => snake_Eating_Train
    var camelCaseTo_snake_Eating_Train: String {
        replacingOccurrences(of: "([A-Z,\\d]+)", with: "_$1",
                             options: .regularExpression, range: nil)
    }

    /// camelCase => SCREAMING_SNAKE
    var camelCaseTo_SCREAMING_SNAKE: String {
        camelCaseTo_snake_Eating_Train.uppercased()
    }

    enum Transcoding {
        public static func snakeToPascalCase(_ input: String) -> String {
            input.pascalCasedSnake
        }

        public static func snakeToCamelCase(_ input: String) -> String {
            input.camelCasedSnake
        }
    }
}
