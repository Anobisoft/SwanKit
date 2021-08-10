//
//  JSONEncodingExt.swift
//  SwanKit
//
//  Created by Stanislav Pletnev on 2020-01-31.
//  Copyright © 2020 Anobisoft. All rights reserved.
//

import Foundation

public extension JSONEncoder {

    convenience init(_ strategy: KeyEncodingStrategy) {
        self.init()
        self.keyEncodingStrategy = strategy
    }

    convenience init(_ strategy: DataEncodingStrategy) {
        self.init()
        self.dataEncodingStrategy = strategy
    }

    convenience init(_ strategy: DateEncodingStrategy) {
        self.init()
        self.dateEncodingStrategy = strategy
    }

    convenience init(_ strategy: NonConformingFloatEncodingStrategy) {
        self.init()
        self.nonConformingFloatEncodingStrategy = strategy
    }
}

public extension JSONEncoder {

    func keyEncodingStrategy(_ strategy: KeyEncodingStrategy) -> JSONEncoder {
        self.keyEncodingStrategy = strategy
        return self
    }

    func dateEncodingStrategy(_ strategy: DateEncodingStrategy) -> JSONEncoder {
        self.dateEncodingStrategy = strategy
        return self
    }

    func dataEncodingStrategy(_ strategy: DataEncodingStrategy) -> JSONEncoder {
        self.dataEncodingStrategy = strategy
        return self
    }

    func nonConformingFloatEncodingStrategy(_ strategy: NonConformingFloatEncodingStrategy) -> JSONEncoder {
        self.nonConformingFloatEncodingStrategy = strategy
        return self
    }
}

public extension JSONEncoder.KeyEncodingStrategy {
    static func customizable<T: CodingKey>(_ type: T.Type) -> Self {
        .custom { (keys) -> CodingKey in
            let last = keys.last!
            if let customizable = last as? CustomizableCodingKeyMapping {
                return customizable.mapped
            }
            return T(stringValue: last.stringValue) ?? last
        }
    }

    static let convertToScreamingSnakeCase = customizable(ScreamingSnakeKey.self)
}

public struct ScreamingSnakeKey: CodingKey {
    public init?(stringValue: String) {
        self.stringValue = stringValue.camelCaseTo_SCREAMING_SNAKE
    }

    public init?(intValue: Int) {
        stringValue = String(intValue)
    }

    public var stringValue: String
    public var intValue: Int?
}

