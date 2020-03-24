//
//  Codable.swift
//  SwanKit
//
//  Created by Stanislav Pletnev on 2020-01-24.
//  Copyright © 2020 Anobisoft. All rights reserved.
//

import Foundation

public extension JSONDecoder {
    func decode<T: Decodable>(_ data: Data) throws -> T {
        try self.decode(T.self, from: data)
    }
}

public extension Encodable {
    func encode(encoder: JSONEncoder = JSONEncoder()) throws -> Data {
        try encoder.encode(self)
    }
}

public extension Decodable {
    static func decode(data: Data, decoder: JSONDecoder = JSONDecoder()) throws -> Self {
        try decoder.decode(Self.self, from: data)
    }
}

public extension Data {
    func decode<T: Decodable>(decoder: JSONDecoder = JSONDecoder()) throws -> T {
        try decoder.decode(T.self, from: self)
    }
}

public protocol CustomizableCodingKeyMapping: CodingKey {
    var mapped: CodingKey { get }
}

public extension CustomizableCodingKeyMapping {
    var mapped: CodingKey {
        self
    }
}
