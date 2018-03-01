//
//  CounterViewModel.swift
//  DiffMVPAndMVVM
//
//  Created by marty-suzuki on 2018/03/02.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import Foundation

final class CounterViewModel {
    var didUpdatePlaceValues: (([String]) -> ())?

    var placeValues: [String] {
        return _placeValues.map { "\($0)" }
    }

    private var _placeValues: [Int] {
        didSet {
            _placeValues.enumerated().forEach { arg in
                if oldValue[arg.offset] == arg.element { return }
                center.post(name: notificatinName, object: arg.offset)
            }
        }
    }
    private let maxValue: Int
    private var _count: Int = 0
    private var count: Int {
        set {
            if newValue > maxValue {
                _count = maxValue
            } else {
                _count = newValue
            }
        }
        get {
            return _count
        }
    }
    private let notificatinName = Notification.Name("CounterViewModel.placeValues_changed")
    private let center = NotificationCenter()
    private var observers: [NSObjectProtocol] = []

    deinit {
        observers.forEach { center.removeObserver($0) }
    }

    init(numberOfPlaceValues: Int) {
        let placeValues = (0..<numberOfPlaceValues).map { _ in 0 }
        self._placeValues = placeValues
        self.maxValue = (Int(pow(Double(10), Double(placeValues.count + 1))) - 1)
    }

    @objc func increment() {
        count += 1

        _placeValues = _placeValues.enumerated().map { arg -> Int in
            let (offset, _) = arg
            let v1 = Int(pow(Double(10), Double(offset)))
            let v2 = Int(pow(Double(10), Double(offset + 1)))
            return count % v2 / v1
        }
    }

    @objc func incrementEachPlaceValues() {
        let values = _placeValues
        let maxValue = values.reduce(0, max)
        let minValue = values.reduce(maxValue, min)

        if values.filter({ $0 == maxValue }).count == values.count {
            if maxValue == 9 {
                _placeValues = values.map { _ in 0 }
            } else {
                _placeValues = values.map { $0 + 1 }
            }
        } else {
            _placeValues = values.map { value in
                value == minValue ? value + 1 : value
            }
        }

        count = _placeValues.enumerated().reduce(0) { (result, arg) -> Int in
            result + Int(pow(Double(10), Double(arg.offset))) * arg.element
        }
    }

    @objc func decrementEachPlaceValues() {
        let values = _placeValues
        let maxValue = values.reduce(0, max)
        let minValue = values.reduce(maxValue, min)

        if values.filter({ $0 == minValue }).count == values.count {
            if minValue == 0 {
                _placeValues = values.map { _ in 9 }
            } else {
                _placeValues = values.map { $0 - 1 }
            }
        } else {
            _placeValues = values.map { value in
                value == maxValue ? value - 1 : value
            }
        }

        count = _placeValues.enumerated().reduce(0) { (result, arg) -> Int in
            result + Int(pow(Double(10), Double(arg.offset))) * arg.element
        }
    }

    func observePlaceValues<T: AnyObject, V>(at index: Int,
                                             bindTo target: T,
                                             _ keyPath: ReferenceWritableKeyPath<T, V>) {
        let handler: (Int) -> () = { [weak self, weak target] changedIndex in
            guard
                changedIndex == index,
                let me = self, let target = target,
                let value = me.placeValues[index] as? V
                else { return }
            target[keyPath: keyPath] = value
        }
        let observer = center.addObserver(forName: notificatinName, object: nil, queue: .main) {
            if let object = $0.object as? NSNumber {
                handler(object.intValue)
            }
        }
        observers.append(observer)
    }
}
