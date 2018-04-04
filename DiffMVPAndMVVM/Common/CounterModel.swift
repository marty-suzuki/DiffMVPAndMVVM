//
//  CounterModel.swift
//  DiffMVPAndMVVM
//
//  Created by marty-suzuki on 2018/04/05.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import Foundation

protocol CounterModelType: class {
    var count: Int { get }
    var maxValue: Int { get }
    init(numberOfDigits: Int, changed: @escaping (Int) -> ())
    func array(from count: Int,  numberOfDigits: Int) -> [Int]
    func increment()
    func incrementAllIfNeeded()
    func decrementAllIfNeeded()
}

final class CounterModel: CounterModelType {
    private(set) var count: Int = 0 {
        didSet { changed(count) }
    }
    let maxValue: Int
    private let numberOfDigits: Int
    private let changed: (Int) -> ()

    init(numberOfDigits: Int, changed: @escaping (Int) -> ()) {
        self.numberOfDigits = numberOfDigits
        self.maxValue = (Int(pow(10, Double(numberOfDigits))) - 1)
        self.changed = changed
        changed(count)
    }

    func increment() {
        let newCount = count + 1
        if newCount > newCount {
            count = 0
        } else {
            count = newCount
        }
    }

    func incrementAllIfNeeded() {
        let values = array(from: count, numberOfDigits: numberOfDigits)

        let newValues: [Int] = {
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
        }()

        count = int(from: newValues)
    }

    func decrementAllIfNeeded() {
        let values = array(from: count, numberOfDigits: numberOfDigits)

        let newValues: [Int] = {
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
        }()

        count = int(from: newValues)
    }

    func array(from count: Int,  numberOfDigits: Int) -> [Int] {
        return (0..<numberOfDigits).map { offset -> Int in
            let v1 = Int(pow(Double(10), Double(offset)))
            let v2 = Int(pow(Double(10), Double(offset + 1)))
            return count % v2 / v1
        }
    }

    private func int(from array: [Int]) -> Int {
        return array.enumerated().reduce(0) { (result, arg) -> Int in
            result + Int(pow(Double(10), Double(arg.offset))) * arg.element
        }
    }
}
