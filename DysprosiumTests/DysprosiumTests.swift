//
//  DysprosiumTests.swift
//  DysprosiumTests
//
//  Created by Bas van Kuijck on 17-08-16.
//  Copyright © 2016 E-sites. All rights reserved.
//

import XCTest
import UIKit
@testable import Dysprosium

class DysprosiumTests: XCTestCase {
    override func setUp() {
        super.setUp()
        Dysprosium.shared.isEnabled = true
    }

    override func tearDown() {
        super.tearDown()
    }

    fileprivate var tmpObject: Object?
    fileprivate var tmpObject2: ObjectWithChild?
    fileprivate var tmpObject3: ObjectDoubleDealloc?

    func testDeallocationOfObject() {
        let exp = expectation(description: "dealloc")
        tmpObject = Object()

        Dysprosium.shared.onDealloc { objects in
            XCTAssertEqual(objects.count, 1)
            XCTAssert(!(objects.filter { $0.className == "Object" }).isEmpty, "objects should hold 'Object'")
            exp.fulfill()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.tmpObject = nil
        }
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testChild() {
        let exp = expectation(description: "dealloc")
        tmpObject2 = ObjectWithChild()

        Dysprosium.shared.onDealloc { objects in
            XCTAssert(!(objects.filter { $0.className == "Object" }).isEmpty, "objects should hold 'Object'")
            XCTAssert(!(objects.filter { $0.className == "ObjectWithChild" }).isEmpty,
                      "objects should hold 'ObjectWithChild'")
            exp.fulfill()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.tmpObject2 = nil
        }
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testDoubleDealloc() {
        let exp = expectation(description: "dealloc")
        tmpObject3 = ObjectDoubleDealloc()

        Dysprosium.shared.onDealloc { objects in
            XCTAssertEqual(objects.count, 1)
            XCTAssert(!(objects.filter { $0.className == "ObjectDoubleDealloc" }).isEmpty,
                      "objects should hold 'ObjectDoubleDealloc'")
            exp.fulfill()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.tmpObject3 = nil
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
}


private class Object: DysprosiumCompatible {
    deinit {
        deallocated()
    }
}

private class ObjectWithChild: Object {
    let childObject = Object()
}

private class ObjectDoubleDealloc: DysprosiumCompatible {
    deinit {
        deallocated()
        deallocated()
    }
}
