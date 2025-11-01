
import Foundation

// MARK: - Map to Dictionary

public extension Dictionary {
    func mapToDictionary<K: Hashable, V>(_ transform: (Key, Value) throws -> (K, V)) rethrows -> [K: V] {
        [K: V](uniqueKeysWithValues: try map(transform))
    }

    func mapKeys<K: Hashable>(_ transform: (Key) throws -> K) rethrows -> [K: Value] {
        try mapToDictionary { key, value in
            (try transform(key), value)
        }
    }
}

// MARK: - CompactMap to Dictionary

public extension Dictionary {
    func compactMapToDictionary<K: Hashable, V>(_ transform: (Key, Value) throws -> (K, V)?) rethrows -> [K: V] {
        [K: V](uniqueKeysWithValues: try compactMap(transform))
    }

    func compactMapKeys<K: Hashable>(_ transform: (Key) throws -> K?) rethrows -> [K: Value] {
        try compactMapToDictionary { key, value in
            guard
                let key = try transform(key)
            else { return nil }
            return (key, value)
        }
    }

    func compactMapKeys<K: Hashable, V>(_ transform: (Key) throws -> K?) rethrows -> [K: V]
        where Value == Optional<V> {
        try compactMapToDictionary { key, value in
            guard
                let value,
                let key = try transform(key)
            else { return nil }
            return (key, value)
        }
    }

    func compactMapValues<V>() -> [Key: V] where Value == Optional<V> {
        compactMapValues { $0 }
    }
}

// MARK: - Key: RawRepresentable

public extension Dictionary where Key: RawRepresentable {
    func resolveRepresentation<K: Hashable>() -> [K: Value]
        where Key.RawValue == K {
        mapKeys { $0.rawValue }
    }

    func resolveRepresentation<K: Hashable, V>() -> [K: V]
        where Key.RawValue == K, V: RawRepresentable, V.RawValue == Value {
        compactMapToDictionary { key, value in
            guard
                let value = V(rawValue: value)
            else { return nil }
            return (key.rawValue, value)
        }
    }

    // MARK: Optional Value

    func resolveRepresentation<K, V>() -> [K: V]
        where Key.RawValue == K, Value == Optional<V> {
        compactMapKeys { $0.rawValue }
    }

    func resolveRepresentation<K, V, W>() -> [K: V]
        where Key.RawValue == K, Value == Optional<W>, W: RawRepresentable, V == W.RawValue {
        compactMapToDictionary { key, value in
            guard let value else { return nil }
            return (key.rawValue, value.rawValue)
        }
    }

    func resolveRepresentation<K, V, W>() -> [K: V]
        where Key.RawValue == K, Value == Optional<W>, V: RawRepresentable, V.RawValue == W {
        compactMapToDictionary { key, value in
            guard
                let value,
                let value = V(rawValue: value)
            else { return nil }
            return (key.rawValue, value)
        }
    }
}

// MARK: - Value: RawRepresentable

public extension Dictionary where Value: RawRepresentable {
    func resolveRepresentation<V>() -> [Key: V] where Value.RawValue == V {
        mapValues { $0.rawValue }
    }

    func resolveRepresentation<K, V>() -> [K: V]
        where K: RawRepresentable, K.RawValue == Key, Value.RawValue == V {
        compactMapToDictionary { key, value in
            guard
                let key = K(rawValue: key)
            else { return nil }
            return (key, value.rawValue)
        }
    }
}

// MARK: - Key: RawRepresentable, Value: RawRepresentable

public extension Dictionary where Key: RawRepresentable, Value: RawRepresentable {
    func resolveRepresentation<K: Hashable, V>() -> [K: V] where Key.RawValue == K, Value.RawValue == V {
        mapToDictionary { key, value in
            return (key.rawValue, value.rawValue)
        }
    }
}

// MARK: - K: RawRepresentable / V: RawRepresentable

public extension Dictionary {
    func resolveRepresentation<K: Hashable>() -> [K: Value]
        where K: RawRepresentable, K.RawValue == Key {
        compactMapKeys { K(rawValue: $0) }
    }

    func resolveRepresentation<V>() -> [Key: V]
        where V: RawRepresentable, V.RawValue == Value {
        compactMapValues { V(rawValue: $0) }
    }

    func resolveRepresentation<K: Hashable, V>() -> [K: V]
        where K: RawRepresentable, K.RawValue == Key, V: RawRepresentable, V.RawValue == Value {
        compactMapToDictionary { key, value in
            guard
                let key = K(rawValue: key),
                let value = V(rawValue: value)
            else { return nil }
            return (key, value)
        }
    }
}

// MARK: - Optional Values

public extension Dictionary {
    func resolveRepresentation<V>() -> [Key: V] where Value == Optional<V> {
        compactMapValues()
    }

    func resolveRepresentation<V, W>() -> [Key: V]
        where Value == Optional<W>, W: RawRepresentable, V == W.RawValue {
        compactMapValues { $0?.rawValue }
    }

    func resolveRepresentation<V, W>() -> [Key: V]
        where Value == Optional<W>, V: RawRepresentable, V.RawValue == W {
        compactMapValues { value in
            guard let value else { return nil }
            return V(rawValue: value)
        }
    }

    func resolveRepresentation<K, V>() -> [K: V]
        where K: RawRepresentable, K.RawValue == Key, Value == Optional<V> {
        compactMapKeys { K(rawValue: $0) }
    }

    func resolveRepresentation<K, V, W>() -> [K: V]
        where K: RawRepresentable, K.RawValue == Key, Value == Optional<W>, W: RawRepresentable, V == W.RawValue {
        compactMapToDictionary { key, value in
            guard
                let key = K(rawValue: key),
                let value
            else { return nil }
            return (key, value.rawValue)
        }
    }

    func resolveRepresentation<K, V, W>() -> [K: V]
        where K: RawRepresentable, K.RawValue == Key, Value == Optional<W>, V: RawRepresentable, V.RawValue == W {
        compactMapToDictionary { key, value in
            guard
                let key = K(rawValue: key),
                let value,
                let value = V(rawValue: value)
            else { return nil }
            return (key, value)
        }
    }
}
