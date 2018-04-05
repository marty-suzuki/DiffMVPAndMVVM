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

extension CounterViewMock.UpdateParameters: Equatable {
    static func == (lhs: CounterViewMock.UpdateParameters, rhs: CounterViewMock.UpdateParameters) -> Bool {
        return lhs.index == rhs.index && lhs.text == rhs.text
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
        self.presetner = CounterPresenter(numberOfDigits: 4, view: counterView)
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

    func testUpButtonTap() {
        let lastValue = results!
        XCTAssertEqual(lastValue.count, 4)
        presetner.upButtonTap()

        XCTAssertNotEqual(lastValue, results)
        XCTAssertEqual(results.count, 8)
        XCTAssertEqual(results[4].text, "1")
        XCTAssertEqual(results[5].text, "1")
        XCTAssertEqual(results[6].text, "1")
        XCTAssertEqual(results[7].text, "1")
    }

    func testDownButtonTap() {
        let firstValueCount: Int = 4
        let incrementCount: Int = 211
        (1...incrementCount).forEach { _ in presetner.incrementButtonTap() }
        let lastValue = results!

        do {
            let estimatedCount = incrementCount * 4 + firstValueCount
            XCTAssertEqual(lastValue.count, estimatedCount)

            let value = Array(lastValue[(lastValue.count - 4)..<lastValue.count])
            print(value)
            XCTAssertEqual(value[0].text, "1")
            XCTAssertEqual(value[1].text, "1")
            XCTAssertEqual(value[2].text, "2")
            XCTAssertEqual(value[3].text, "0")
        }

        presetner.downButtonTap()

        do {
            XCTAssertNotEqual(lastValue, results)

            let estimatedCount = incrementCount * 4 + firstValueCount + 4
            XCTAssertEqual(results.count, estimatedCount)

            let value = Array(results[(results.count - 4)..<results.count])
            XCTAssertEqual(value[0].text, "1")
            XCTAssertEqual(value[1].text, "1")
            XCTAssertEqual(value[2].text, "1")
            XCTAssertEqual(value[3].text, "0")
        }
    }
}
