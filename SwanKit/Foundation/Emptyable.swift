//
//  Optional.swift
//  SwanKit
//
//  Created by Stanislav Pletnev on 2024-12-03.
//  Copyright © 2024 Anobisoft. All rights reserved.
//

import Foundation

public protocol Emptyable {
    associatedtype ValueType: Emptyable
    var isEmpty: Bool { get }
    static var empty: ValueType { get }
}

extension Emptyable {
    var isNotEmpty: Bool { !isEmpty }
}

postfix operator ^||

extension Optional where Wrapped: Emptyable, Wrapped.ValueType == Wrapped {
    var orEmpty: Wrapped {
        if case let .some(value) = self {
            value
        } else {
            .empty
        }
    }

    static postfix func ^|| (value: Wrapped?) -> Wrapped {
        value.orEmpty
    }
}

extension String: Emptyable {
    public typealias ValueType = Self
    public static var empty: Self { "" }
}

extension Array: Emptyable {
    public typealias ValueType = Self
    public static var empty: Self { [] }
}

extension Dictionary: Emptyable {
    public typealias ValueType = Self
    public static var empty: Self { [:] }
}

extension Set: Emptyable {
    public typealias ValueType = Self
    public static var empty: Self { [] }
}
