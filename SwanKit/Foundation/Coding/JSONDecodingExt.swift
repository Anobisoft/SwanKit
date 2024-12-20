//
//  JSONDecodingExt.swift
//  SwanKit
//
//  Created by Stanislav Pletnev on 2019-11-28.
//  Copyright © 2019 Anobisoft. All rights reserved.
//

import Foundation

public extension JSONDecoder {
    convenience init(strategy: KeyDecodingStrategy) {
        self.init()
        self.keyDecodingStrategy = keyDecodingStrategy
    }

    convenience init(strategy: DataDecodingStrategy) {
        self.init()
        self.dataDecodingStrategy = strategy
    }

    convenience init(strategy: DateDecodingStrategy) {
        self.init()
        self.dateDecodingStrategy = strategy
    }

    convenience init(strategy: NonConformingFloatDecodingStrategy) {
        self.init()
        self.nonConformingFloatDecodingStrategy = strategy
    }
}

public extension JSONDecoder {
    func keyDecodingStrategy(_ strategy: KeyDecodingStrategy) -> Self {
        self.keyDecodingStrategy = strategy
        return self
    }

    func dateDecodingStrategy(_ strategy: DateDecodingStrategy) -> Self {
        self.dateDecodingStrategy = strategy
        return self
    }

    func dataDecodingStrategy(_ strategy: DataDecodingStrategy) -> Self {
        self.dataDecodingStrategy = strategy
        return self
    }

    func nonConformingFloatDecodingStrategy(_ strategy: NonConformingFloatDecodingStrategy) -> Self {
        self.nonConformingFloatDecodingStrategy = strategy
        return self
    }
}

public extension JSONDecoder.KeyDecodingStrategy {
    static func customizable<T: CodingKey>(_ type: T.Type) -> Self {
        .custom { (keys) -> CodingKey in
            let last = keys.last!
            if let customizable = last as? CustomizableCodingKeyMapping {
                return customizable.mapped
            }
            return T(stringValue: last.stringValue) ?? last
        }
    }

    static let convertFromSnakeCaseExtended = customizable(CamelKey.self)
}

public struct CamelKey: CodingKey {
    public init?(stringValue: String) {
        self.stringValue = stringValue.camelCasedSnake
    }
    
    public init?(intValue: Int) {
        stringValue = String(intValue)
    }
    
    public var stringValue: String
    public var intValue: Int?
}
