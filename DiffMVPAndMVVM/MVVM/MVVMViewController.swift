//
//  MVVMViewController.swift
//  DiffMVPAndMVVM
//
//  Created by marty-suzuki on 2018/03/02.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class MVVMViewController<ViewModel: CounterViewModelType>: UIViewController {
    @IBOutlet private(set) var labels: [UILabel]! {
        didSet {
            labels.forEach { label in
                label.layer.cornerRadius = 4
                label.layer.borderWidth = 1
                label.layer.borderColor = UIColor.lightGray.cgColor
                label.layer.masksToBounds = true
                label.textColor = UIColor.darkText
            }
        }
    }
    @IBOutlet private(set) weak var incrementButton: UIButton!
    @IBOutlet private(set) weak var upButton: UIButton!
    @IBOutlet private(set) weak var downButton: UIButton!

    private let disposeBag = DisposeBag()
    private(set) lazy var viewModel: ViewModel = {
        .init(numberOfDigits: self.labels.count,
              incrementButtonTap: self.incrementButton.rx.tap.asObservable(),
              upButtonTap: self.upButton.rx.tap.asObservable(),
              downButtonTap: self.downButton.rx.tap.asObservable())
    }()

    init() {
        let nibName = "MVVMViewController"
        super.init(nibName: nibName, bundle: nil)
        self.title = nibName
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.placeValues
            .bind(to: Binder(self) { me, values in
                values.enumerated().forEach { me.labels[$0].text = $1 }
            })
            .disposed(by: disposeBag)
    }
}
