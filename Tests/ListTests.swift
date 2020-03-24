//
//  ListTests.swift
//  ListTests
//
//  Created by Stanislav Pletnev on 2019-27-11.
//  Copyright © 2019 Anobisoft. All rights reserved.
//

import XCTest
@testable import SwanKit

class A {
    let id = UUID()
}

extension A: Equatable {
    static func == (lhs: A, rhs: A) -> Bool {
        lhs.id == rhs.id
    }
}

class ListTests: XCTestCase {

    var list: WeakList<A>!
    var array: [A]!
    var retain: [A]!


    override func setUp() {
        list = WeakList()
        let a2 = A()
        let a3 = A()
        array = [A(), A(),
                 a2, a3,
                 A(), A(),
                 A(), A()]
        retain = [a2, a3]
    }

    override func tearDown() {
        list = nil
        array = nil
        retain = nil
    }

    func testAutoreleasing() {
        autoreleasepool {
            var count = 0
            for object in array {
                count += 1
                list <+ object
                XCTAssertEqual(list.count, count)
            }
            XCTAssertEqual(list.count, array.count)
            list.forEach { XCTAssertTrue(array.contains($0)) }
            array = nil
        }
        var strictlyCount = 0
        list.forEach { _ in strictlyCount += 1 }
        XCTAssertEqual(strictlyCount, retain.count)
        XCTAssertEqual(strictlyCount, list.count)
        var index = 0
        list.forEach {
            XCTAssertEqual(retain[index], $0)
            index += 1
        }
    }
}

class ListPerformanceTest: XCTestCase {

    var list: RetainList<Int>!

    override func setUp() {
        list = RetainList()
    }

    func testPerformance() {
        self.measure {
            for i in 0...500000 {
                list <+ i
            }
            list.clear()
        }
    }
}
