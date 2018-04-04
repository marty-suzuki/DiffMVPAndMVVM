//
//  CounterViewModel.swift
//  DiffMVPAndMVVM
//
//  Created by marty-suzuki on 2018/03/02.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import RxSwift
import RxCocoa

protocol CounterViewModelType: class {
    var placeValues: Observable<[String]> { get }
    init(numberOfPlaceValues: Int,
         incrementButtonTap: Observable<Void>,
         upButtonTap: Observable<Void>,
         downButtonTap: Observable<Void>)
}

final class CounterViewModel: CounterViewModelType {
    let placeValues: Observable<[String]>

    private let disposeBag = DisposeBag()

    init(numberOfPlaceValues: Int,
         incrementButtonTap: Observable<Void>,
         upButtonTap: Observable<Void>,
         downButtonTap: Observable<Void>) {
        let _placeValues = PublishRelay<[Int]>()

        do { // This part is different from implementation of ConunterPresenter.
            let value = BehaviorRelay<[Int]>(value: [])
            _placeValues
                .skip(1)
                .bind(to: value)
                .disposed(by: disposeBag)

            self.placeValues = value
                .filter { !$0.isEmpty }
                .map { $0.map { "\($0)" } }
        }

        do { // This part is same as implementaion of ConunterPresenter.
            let _count = PublishRelay<Int>()
            _count
                .withLatestFrom(_placeValues) { ($0, $1) }
                .map { count, values -> [Int] in
                    values.enumerated().map { arg -> Int in
                        let (offset, _) = arg
                        let v1 = Int(pow(Double(10), Double(offset)))
                        let v2 = Int(pow(Double(10), Double(offset + 1)))
                        return count % v2 / v1
                    }
                }
                .bind(to: _placeValues)
                .disposed(by: disposeBag)

            let newPlaceValues1 = upButtonTap
                .withLatestFrom(_placeValues)
                .map { values -> [Int] in
                    let maxValue = values.reduce(0, max)
                    let minValue = values.reduce(maxValue, min)

                    if values.filter({ $0 == maxValue }).count == values.count {
                        if maxValue == 9 {
                            return values.map { _ in 0 }
                        } else {
                            return values.map { $0 + 1 }
                        }
                    } else {
                        return values.map { value in
                            value == minValue ? value + 1 : value
                        }
                    }
                }

            let newPlaceValues2 = downButtonTap
                .withLatestFrom(_placeValues)
                .map { values -> [Int] in
                    let maxValue = values.reduce(0, max)
                    let minValue = values.reduce(maxValue, min)

                    if values.filter({ $0 == minValue }).count == values.count {
                        if minValue == 0 {
                            return values.map { _ in 9 }
                        } else {
                            return values.map { $0 - 1 }
                        }
                    } else {
                        return values.map { value in
                            value == maxValue ? value - 1 : value
                        }
                    }
                }

            Observable.merge(newPlaceValues1, newPlaceValues2)
                .map { values -> Int in
                    values.enumerated().reduce(0) { (result, arg) -> Int in
                        result + Int(pow(Double(10), Double(arg.offset))) * arg.element
                    }
                }
                .bind(to: _count)
                .disposed(by: disposeBag)

            let placeValues = (0..<numberOfPlaceValues).map { _ in 0 }
            let maxValue = (Int(pow(10, Double(placeValues.count))) - 1)
            incrementButtonTap
                .withLatestFrom(_count)
                .map {
                    let newValue = $0 + 1
                    return newValue > maxValue ? 0 : newValue
                }
                .bind(to: _count)
                .disposed(by: disposeBag)

            _placeValues.accept(placeValues)
            _count.accept(0)
        }
    }
}
