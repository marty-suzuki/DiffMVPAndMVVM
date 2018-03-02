//
//  CounterPresenter.swift
//  DiffMVPAndMVVM
//
//  Created by 鈴木大貴 on 2018/03/02.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import RxSwift
import RxCocoa

final class CounterPresenter {
    private weak var view: CounterView?

    private let _incrementButtonTap = PublishRelay<Void>()
    private let _upButtonTap = PublishRelay<Void>()
    private let _downButtonTap = PublishRelay<Void>()

    private let disposeBag = DisposeBag()

    init(numberOfPlaceValues: Int, view: CounterView) {
        self.view = view
        
        let _placeValues = PublishRelay<[Int]>()
        _placeValues
            .map { $0.map { "\($0)" } }
            .observeOn(ConcurrentMainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                $0.enumerated().forEach {
                    self?.view?.updateLabel(at: $0, text: $1)
                }
            })
            .disposed(by: disposeBag)

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

        let newPlaceValues1 = _upButtonTap
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

        let newPlaceValues2 = _downButtonTap
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
        let maxValue = (Int(pow(Double(10), Double(placeValues.count + 1))) - 1)
        _incrementButtonTap
            .withLatestFrom(_count)
            .map { $0 + 1 }
            .filter { $0 <= maxValue }
            .bind(to: _count)
            .disposed(by: disposeBag)

        _placeValues.accept(placeValues)
        _count.accept(0)
    }

    @objc func incrementButtonTap() {
        _incrementButtonTap.accept(())
    }

    @objc func upButtonTap() {
        _upButtonTap.accept(())
    }

    @objc func downButtonTap() {
        _downButtonTap.accept(())
    }
}