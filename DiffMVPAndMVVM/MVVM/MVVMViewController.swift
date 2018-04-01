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

final class MVVMViewController: UIViewController {
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
    @IBOutlet private weak var incrementButton: UIButton!
    @IBOutlet private weak var upButton: UIButton!
    @IBOutlet private weak var downButton: UIButton!

    private let disposeBag = DisposeBag()
    private lazy var viewModel: CounterViewModelType = {
        CounterViewModel(numberOfPlaceValues: self.labels.count,
                         incrementButtonTap: self.incrementButton.rx.tap.asObservable(),
                         upButtonTap: self.upButton.rx.tap.asObservable(),
                         downButtonTap: self.downButton.rx.tap.asObservable())
    }()

    init(viewModel: CounterViewModelType? = nil) {
        super.init(nibName: MVVMViewController.className, bundle: nil)
        
        if let viewModel = viewModel {
            self.viewModel = viewModel
        }
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
