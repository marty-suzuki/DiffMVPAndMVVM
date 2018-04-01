//
//  CounterPresenterTestCase.swift
//  DiffMVPAndMVVMTests
//
//  Created by marty-suzuki on 2018/04/02.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import XCTest
@testable import DiffMVPAndMVVM

// MARK: - Mock
final class CounterViewMock: CounterView {
    struct UpdateParameters {
        let index: Int
        let text: String
    }

    private let didCallUpdateLabel: (UpdateParameters) -> ()

    init(didCallUpdateLabel: @escaping (UpdateParameters) -> ()) {
        self.didCallUpdateLabel = didCallUpdateLabel
    }

    func updateLabel(at index: Int, text: String) {
        didCallUpdateLabel(UpdateParameters(index: index, text: text))
    }
}

// MARK: - TestCase
final class CounterPresenterTestCase: XCTestCase {
    private var counterView: CounterViewMock!
    private var presetner: CounterPresenter!
    private var results: [CounterViewMock.UpdateParameters]!
    
    override func setUp() {
        super.setUp()

        self.results = []
        let counterView = CounterViewMock() { [weak self] result in
            self?.results.append(result)
        }
        self.presetner = CounterPresenter(numberOfPlaceValues: 4, view: counterView)
        self.counterView = counterView
    }

    func testInitialValue() {
        XCTAssertEqual(results.count, 4)
        results.forEach { value in
            XCTAssertEqual(value.text, "0")
        }
    }

    func testIncrementButtonTap() {
        XCTAssertEqual(results.count, 4)
        presetner.incrementButtonTap()

        XCTAssertEqual(results.count, 8)
        XCTAssertEqual(results[4].text, "1")
        XCTAssertEqual(results[5].text, "0")
        XCTAssertEqual(results[6].text, "0")
        XCTAssertEqual(results[7].text, "0")
    }
}
