//
//  Cache.swift
//  SwanKit
//
//  Created by Stanislav Pletnev on 2019-11-29.
//  Copyright © 2019 Anobisoft. All rights reserved.
//

import Foundation

public protocol CacheDelegate: class {
    func cache<KeyType: AnyObject, ObjectType: AnyObject>(_ cache: Cache<KeyType, ObjectType>, willEvict object: ObjectType)
}

public protocol Costable {
    var cost: Int { get }
}

public class Cache<KeyType: AnyObject, ObjectType: AnyObject> {

    public weak var delegate: CacheDelegate?

    public init() {
        delegateProxy = CacheDelegateProxy { [weak self] (object) in
            guard let self = self, let object = object as? ObjectType else { return }
            self.delegate?.cache(self, willEvict: object)
        }
        cache.delegate = delegateProxy
    }
    
    public subscript(key: KeyType) -> ObjectType? {
        get {
            return cache.object(forKey: key)
        }
        set {
            if let newValue = newValue {
                cache.setObject(newValue, forKey: key)
            }
            else {
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

    //MARK: - Private
    private let cache = NSCache<KeyType, ObjectType>()
    private var delegateProxy: CacheDelegateProxy!
}

extension Cache where ObjectType: Costable {
    
    public var totalCostLimit: Int {
        get { cache.totalCostLimit }
        set { cache.totalCostLimit = newValue }
    }

    public subscript(key: KeyType) -> ObjectType? {
        get {
            return cache.object(forKey: key)
        }
        set {
            if let newValue = newValue {
                cache.setObject(newValue, forKey: key, cost: newValue.cost)
            }
            else {
                cache.removeObject(forKey: key)
            }
        }
    }
}

private class CacheDelegateProxy: NSObject, NSCacheDelegate {

    typealias Callback = (_ obj: Any) -> Void

    init(callback: @escaping Callback) {
        self.callback = callback
    }

    private let callback: Callback

    func cache(_ cache: NSCache<AnyObject, AnyObject>, willEvictObject obj: Any) {
        callback(obj)
    }
}

extension NSData: Costable {
    public var cost: Int {
        length
    }
}
