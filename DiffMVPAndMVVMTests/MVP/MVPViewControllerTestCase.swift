//
//  MVPViewControllerTestCase.swift
//  DiffMVPAndMVVMTests
//
//  Created by marty-suzuki on 2018/04/02.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import XCTest
@testable import DiffMVPAndMVVM

// MARK: - Mock
final class CounterPresenterMock: CounterPresenterType {
    init(numberOfPlaceValues: Int, view: CounterView) {

    }

    @objc func incrementButtonTap() {}
    @objc func upButtonTap() {}
    @objc func downButtonTap() {}
}

// MARK: - TestCase
final class MVPViewControllerTestCase: XCTestCase {
    private var viewController: MVPViewController<CounterPresenterMock>!

    override func setUp() {
        super.setUp()

        let viewController = MVPViewController<CounterPresenterMock>()
        _ = viewController.view
        self.viewController = viewController
    }

    func testNumberOfLabels() {
        XCTAssertEqual(viewController.labels.count, 4)
    }

    func testUpdateLabelAtIndex0To1() {
        let index: Int = 0
        XCTAssertNotNil(viewController.labels[index].text)
        XCTAssertNotEqual(viewController.labels[index].text, "1")
        viewController.updateLabel(at: index, text: "1")
        XCTAssertEqual(viewController.labels[index].text, "1")
    }

    func testUpdateLabelAtIndex1To2() {
        let index: Int = 1
        XCTAssertNotNil(viewController.labels[index].text)
        XCTAssertNotEqual(viewController.labels[index].text, "2")
        viewController.updateLabel(at: index, text: "2")
        XCTAssertEqual(viewController.labels[index].text, "2")
    }

    func testUpdateLabelAtIndex2To3() {
        let index: Int = 2
        XCTAssertNotNil(viewController.labels[index].text)
        XCTAssertNotEqual(viewController.labels[index].text, "3")
        viewController.updateLabel(at: index, text: "3")
        XCTAssertEqual(viewController.labels[index].text, "3")
    }

    func testUpdateLabelAtIndex3To4() {
        let index: Int = 3
        XCTAssertNotNil(viewController.labels[index].text)
        XCTAssertNotEqual(viewController.labels[index].text, "4")
        viewController.updateLabel(at: index, text: "4")
        XCTAssertEqual(viewController.labels[index].text, "4")
    }
}
