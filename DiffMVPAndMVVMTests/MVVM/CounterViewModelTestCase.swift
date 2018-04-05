//
//  CounterViewModelTestCase.swift
//  DiffMVPAndMVVMTests
//
//  Created by marty-suzuki on 2018/04/02.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa
@testable import DiffMVPAndMVVM

// MARK: - TestCase
final class CounterViewModelTestCase: XCTestCase {
    private var viewModel: CounterViewModel!
    private var incrementButtonTap: PublishRelay<Void>!
    private var upButtonTap: PublishRelay<Void>!
    private var downButtonTap: PublishRelay<Void>!

    private var disposeBag: DisposeBag!
    private var results: BehaviorRelay<[String]>!

    override func setUp() {
        super.setUp()

        let incrementButtonTap = PublishRelay<Void>()
        let upButtonTap = PublishRelay<Void>()
        let downButtonTap = PublishRelay<Void>()
        self.viewModel = CounterViewModel(numberOfDigits: 4,
                                          incrementButtonTap: incrementButtonTap.asObservable(),
                                          upButtonTap: upButtonTap.asObservable(),
                                          downButtonTap: downButtonTap.asObservable())
        self.incrementButtonTap = incrementButtonTap
        self.upButtonTap = upButtonTap
        self.downButtonTap = downButtonTap

        let disposeBag = DisposeBag()
        self.disposeBag = disposeBag
        let results = BehaviorRelay<[String]>(value: [])
        viewModel.placeValues
            .bind(to: results)
            .disposed(by: disposeBag)
        self.results = results
    }

    func testInitialValue() {
        XCTAssertEqual(results.value.count, 4)
        results.value.forEach { value in
            XCTAssertEqual(value, "0")
        }
    }

    func testIncrementButtonTap() {
        let lastValue = results.value
        XCTAssertEqual(lastValue.count, 4)
        incrementButtonTap.accept(())

        XCTAssertNotEqual(lastValue, results.value)
        XCTAssertEqual(results.value.count, 4)
        XCTAssertEqual(results.value[0], "1")
        XCTAssertEqual(results.value[1], "0")
        XCTAssertEqual(results.value[2], "0")
        XCTAssertEqual(results.value[3], "0")
    }

    func testUpButtonTap() {
        let lastValue = results.value
        XCTAssertEqual(lastValue.count, 4)
        upButtonTap.accept(())

        XCTAssertNotEqual(lastValue, results.value)
        XCTAssertEqual(results.value.count, 4)
        XCTAssertEqual(results.value[0], "1")
        XCTAssertEqual(results.value[1], "1")
        XCTAssertEqual(results.value[2], "1")
        XCTAssertEqual(results.value[3], "1")
    }

    func testDownButtonTap() {
        (1...211).forEach { _ in incrementButtonTap.accept(()) }
        let lastValue = results.value
        XCTAssertEqual(lastValue.count, 4)
        XCTAssertEqual(lastValue[0], "1")
        XCTAssertEqual(lastValue[1], "1")
        XCTAssertEqual(lastValue[2], "2")
        XCTAssertEqual(lastValue[3], "0")
        downButtonTap.accept(())

        XCTAssertNotEqual(lastValue, results.value)
        XCTAssertEqual(results.value.count, 4)
        XCTAssertEqual(results.value[0], "1")
        XCTAssertEqual(results.value[1], "1")
        XCTAssertEqual(results.value[2], "1")
        XCTAssertEqual(results.value[3], "0")
    }
}
