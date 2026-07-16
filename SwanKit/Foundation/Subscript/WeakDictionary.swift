//
//  WeakDictionary.swift
//  SwanKit
//
//  Created by Stanislav Pletnev on 2026-07-17.
//  Copyright © 2026 Anobisoft. Licensed under the MIT License.
//

import Foundation
import os

final class WeakWrapper<T: AnyObject> {
    weak var wrapped: T?
    private let id: ObjectIdentifier

    init(_ object: T) {
        wrapped = object
        id = .init(object)
    }
}

extension WeakWrapper: Hashable {
    static func == (lhs: WeakWrapper<T>, rhs: WeakWrapper<T>) -> Bool {
        return lhs.wrapped === rhs.wrapped
    }

    func hash(into hasher: inout Hasher) {
        id.hash(into: &hasher)
    }
}

extension WeakWrapper where T: Hashable {
    static func == (lhs: WeakWrapper<T>, rhs: WeakWrapper<T>) -> Bool {
        guard let lw = lhs.wrapped, let rw = rhs.wrapped else {
            return lhs.wrapped === rhs.wrapped
        }
        return lw == rw
    }
}

public struct WeakDictionary<Key: Hashable & Sendable, Value: AnyObject>: @unchecked Sendable {

    private var dict: [Key: WeakWrapper<Value>] = [:]

    private let lock = OSAllocatedUnfairLock()

    public init() {}

    public subscript(key: Key) -> Value? {
        mutating get {
            lock.lock()
            defer { lock.unlock() }

            guard let wrapper = dict[key] else { return nil }

            if wrapper.wrapped == nil {
                dict.removeValue(forKey: key)
                return nil
            }

            return wrapper.wrapped
        }
        set {
            lock.lock()
            defer { lock.unlock() }

            if let newValue = newValue {
                dict[key] = WeakWrapper(newValue)
            } else {
                dict.removeValue(forKey: key)
            }
        }
    }

    public mutating func removeValue(forKey key: Key) {
        lock.lock()
        defer { lock.unlock() }
        dict.removeValue(forKey: key)
    }
}
