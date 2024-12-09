//
//  Cache.swift
//  SwanKit
//
//  Created by Stanislav Pletnev on 2019-11-29.
//  Copyright © 2019 Anobisoft. All rights reserved.
//

import Foundation

public protocol CacheDelegate: AnyObject {
    func cache<Key: AnyObject, Value: AnyObject>(
        _ cache: Cache<Key, Value>,
        willEvict object: Value
    )
}

public protocol Costable {
    var cost: Int { get }
}

public class Cache<Key: AnyObject, Value: AnyObject> {
    public weak var delegate: CacheDelegate?

    //MARK: - Private
    private let cache = NSCache<Key, Value>()
    private var delegateProxy: CacheDelegateProxy!

    public init() {
        delegateProxy = CacheDelegateProxy { [weak self] object in
            guard let self, let object = object as? Value else { return }
            delegate?.cache(self, willEvict: object)
        }
        cache.delegate = delegateProxy
    }
    
    public subscript(key: Key) -> Value? {
        get {
            cache.object(forKey: key)
        }
        set {
            if let newValue {
                cache.setObject(newValue, forKey: key)
            } else {
                cache.removeObject(forKey: key)
            }
        }
    }

    public func clear() {
        cache.removeAllObjects()
    }
    
    public var countLimit: Int {
        get { cache.countLimit }
        set { cache.countLimit = newValue }
    }
}

extension Cache where Value: Costable {
    public var totalCostLimit: Int {
        get { cache.totalCostLimit }
        set { cache.totalCostLimit = newValue }
    }

    public subscript(key: Key) -> Value? {
        get {
            cache.object(forKey: key)
        }
        set {
            if let newValue {
                cache.setObject(newValue, forKey: key, cost: newValue.cost)
            } else {
                cache.removeObject(forKey: key)
            }
        }
    }
}

extension NSData: Costable {
    public var cost: Int {
        length
    }
}

// MARK: - Private

private class CacheDelegateProxy: NSObject, NSCacheDelegate {
    typealias Callback = (_ obj: Any) -> Void

    private let callback: Callback

    init(callback: @escaping Callback) {
        self.callback = callback
    }

    func cache(_ cache: NSCache<AnyObject, AnyObject>, willEvictObject obj: Any) {
        callback(obj)
    }
}
