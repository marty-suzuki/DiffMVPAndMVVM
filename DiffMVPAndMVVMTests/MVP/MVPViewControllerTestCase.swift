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
    let numberOfDigits: Int
    private(set) weak var view: CounterView?
    private(set) var incrementButtonTapCount: Int = 0
    private(set) var upButtonTapCount: Int = 0
    private(set) var downButtonTapCount: Int = 0

    init(numberOfDigits: Int, view: CounterView) {
        self.numberOfDigits = numberOfDigits
        self.view = view
    }

    @objc func incrementButtonTap() {
        incrementButtonTapCount += 1
    }

    @objc func upButtonTap() {
        upButtonTapCount += 1
    }

    @objc func downButtonTap() {
        downButtonTapCount += 1
    }
}

// MARK: - TestCase
final class MVPViewControllerTestCase: XCTestCase {
    private var viewController: MVPViewController<CounterPresenterMock>!
    private var presenter: CounterPresenterMock!

    override func setUp() {
        super.setUp()

        let viewController = MVPViewController<CounterPresenterMock>()
        _ = viewController.view
        self.viewController = viewController
        self.presenter = viewController.presenter
    }

    func testViewIsSameAsViewController() {
        if let view = viewController.presenter.view as? UIViewController {
            XCTAssertEqual(view, viewController)
        } else {
            XCTFail()
        }
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

    func testNumberOfPlaceValues() {
        XCTAssertEqual(viewController.labels.count, presenter.numberOfDigits)
    }

    func testIncrementButtonTap() {
        XCTAssertEqual(presenter.incrementButtonTapCount, 0)
        viewController.incrementButton.sendActions(for: .touchUpInside)
        XCTAssertEqual(presenter.incrementButtonTapCount, 1)
    }

    func testUpButtonTap() {
        XCTAssertEqual(presenter.upButtonTapCount, 0)
        viewController.upButton.sendActions(for: .touchUpInside)
        XCTAssertEqual(presenter.upButtonTapCount, 1)
    }

    func testDownButtonTapTap() {
        XCTAssertEqual(presenter.downButtonTapCount, 0)
        viewController.downButton.sendActions(for: .touchUpInside)
        XCTAssertEqual(presenter.downButtonTapCount, 1)
    }
}
