//
//  MVVMViewControllerTestCase.swift
//  DiffMVPAndMVVMTests
//
//  Created by marty-suzuki on 2018/04/02.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa
@testable import DiffMVPAndMVVM

// MARK: - Mock
final class CounterViewModelMock: CounterViewModelType {
    var placeValues: Observable<[String]> {
        return _placeValues.asObservable()
    }
    let _placeValues = PublishRelay<[String]>()

    init(numberOfPlaceValues: Int,
         incrementButtonTap: Observable<Void>,
         upButtonTap: Observable<Void>,
         downButtonTap: Observable<Void>) {

    }
}

// MARK: - TestCase
final class MVVMViewControllerTestCase: XCTestCase {
    private var viewController: MVVMViewController<CounterViewModelMock>!
    private var placeValues: PublishRelay<[String]>!

    override func setUp() {
        super.setUp()

        let viewController = MVVMViewController<CounterViewModelMock>()
        _ = viewController.view
        self.viewController = viewController
        self.placeValues = viewController.viewModel._placeValues
    }
    
    func testNumberOfLabels() {
        XCTAssertEqual(viewController.labels.count, 4)
    }

    func testUpdateLabelAtIndex0To1() {
        let index: Int = 0
        XCTAssertNotNil(viewController.labels[index].text)
        XCTAssertNotEqual(viewController.labels[index].text, "1")
        placeValues.accept(["1", "0", "0", "0"])
        XCTAssertEqual(viewController.labels[index].text, "1")
    }

    func testUpdateLabelAtIndex1To2() {
        let index: Int = 1
        XCTAssertNotNil(viewController.labels[index].text)
        XCTAssertNotEqual(viewController.labels[index].text, "2")
        placeValues.accept(["0", "2", "0", "0"])
        XCTAssertEqual(viewController.labels[index].text, "2")
    }

    func testUpdateLabelAtIndex2To3() {
        let index: Int = 2
        XCTAssertNotNil(viewController.labels[index].text)
        XCTAssertNotEqual(viewController.labels[index].text, "3")
        placeValues.accept(["0", "0", "3", "0"])
        XCTAssertEqual(viewController.labels[index].text, "3")
    }

    func testUpdateLabelAtIndex3To4() {
        let index: Int = 3
        XCTAssertNotNil(viewController.labels[index].text)
        XCTAssertNotEqual(viewController.labels[index].text, "4")
        placeValues.accept(["0", "0", "0", "4"])
        XCTAssertEqual(viewController.labels[index].text, "4")
    }
}
