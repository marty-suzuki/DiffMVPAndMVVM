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
    init<Model: CounterModelType>(numberOfDigits: Int,
                                  incrementButtonTap: Observable<Void>,
                                  upButtonTap: Observable<Void>,
                                  downButtonTap: Observable<Void>,
                                  type: Model.Type)
}

final class CounterViewModel: CounterViewModelType {
    let placeValues: Observable<[String]>

    private let model: CounterModelType
    private let disposeBag = DisposeBag()

    init<Model: CounterModelType>(numberOfDigits: Int,
                                  incrementButtonTap: Observable<Void>,
                                  upButtonTap: Observable<Void>,
                                  downButtonTap: Observable<Void>,
                                  type: Model.Type) {
        let _count = BehaviorRelay<Int>(value: 0)
        self.model = Model(numberOfDigits: numberOfDigits,
                           changed: { _count.accept($0) })

        self.placeValues = _count
            .flatMap { [weak model] count -> Observable<[String]> in
                guard let model = model else {
                    return .empty()
                }
                let array = model.array(from: count,
                                        numberOfDigits: numberOfDigits)
                return .just(array.map { "\($0)" })
            }

        incrementButtonTap
            .subscribe(onNext: { [unowned self] in
                self.model.increment()
            })
            .disposed(by: disposeBag)

        upButtonTap
            .subscribe(onNext: { [unowned self] in
                self.model.incrementAllIfNeeded()
            })
            .disposed(by: disposeBag)

        downButtonTap
            .subscribe(onNext: { [unowned self] in
                self.model.decrementAllIfNeeded()
            })
            .disposed(by: disposeBag)
    }
}
