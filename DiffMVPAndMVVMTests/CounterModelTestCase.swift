//
//  CounterModelTestCase.swift
//  DiffMVPAndMVVMTests
//
//  Created by marty-suzuki on 2018/04/05.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import XCTest
@testable import DiffMVPAndMVVM

final class CounterModelTestCase: XCTestCase {
    private var numberOfDigits: Int!
    private var results: [Int]!
    private var model: CounterModel!

    override func setUp() {
        super.setUp()

        self.results = []
        self.numberOfDigits = 4
        self.model = CounterModel(numberOfDigits: numberOfDigits,
                                  changed: { [weak self] in self?.results.append($0) })
    }
    
    func testInitialValue() {
        XCTAssertEqual(model.count, 0)
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results.first, 0)
    }

    func testArray() {
        let array = model.array(from: 1234, numberOfDigits: 4)
        XCTAssertEqual(array.count, 4)
        XCTAssertEqual(array[0], 4)
        XCTAssertEqual(array[1], 3)
        XCTAssertEqual(array[2], 2)
        XCTAssertEqual(array[3], 1)
    }

    func testIncrement() {
        XCTAssertEqual(model.count, 0)

        model.increment()
        XCTAssertEqual(model.count, 1)
    }

    func testIncrementAllIfNeeded() {
        XCTAssertEqual(model.count, 0)

        (1...200).forEach { _ in
            model.increment()
        }
        XCTAssertEqual(model.count, 200)

        model.incrementAllIfNeeded()
        XCTAssertEqual(model.count, 1211)
    }

    func testDecrementAllIfNeeded() {
        XCTAssertEqual(model.count, 0)

        (1...200).forEach { _ in
            model.increment()
        }
        XCTAssertEqual(model.count, 200)

        model.decrementAllIfNeeded()
        XCTAssertEqual(model.count, 100)
    }
}
