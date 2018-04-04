//
//  CounterPresenter.swift
//  DiffMVPAndMVVM
//
//  Created by 鈴木大貴 on 2018/03/02.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import RxSwift
import RxCocoa

@objc protocol CounterPresenterType: class {
    init(numberOfDigits: Int, view: CounterView)
    func incrementButtonTap()
    func upButtonTap()
    func downButtonTap()
}

final class CounterPresenter: CounterPresenterType {
    private weak var view: CounterView?

    private let model: CounterModel
    private let disposeBag = DisposeBag()

    init(numberOfDigits: Int, view: CounterView) {
        let _count = BehaviorRelay<Int>(value: 0)
        self.model = CounterModel(numberOfDigits: numberOfDigits,
                                  changed: { _count.accept($0) })

        self.view = view
        _count
            .flatMap { [weak model] count -> Observable<[String]> in
                guard let model = model else {
                    return .empty()
                }
                let array = model.array(from: count,
                                        numberOfDigits: numberOfDigits)
                return .just(array.map { "\($0)" })
            }
            .bind(to: Binder(self) { me, values in
                values.enumerated().forEach {
                    me.view?.updateLabel(at: $0, text: $1)
                }
            })
            .disposed(by: disposeBag)
    }

    func incrementButtonTap() {
        model.increment()
    }

    func upButtonTap() {
        model.incrementAllIfNeeded()
    }

    func downButtonTap() {
        model.decrementAllIfNeeded()
    }
}
